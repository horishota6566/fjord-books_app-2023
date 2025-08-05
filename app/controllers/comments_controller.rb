class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]
  before_action :set_comment, only: %i[ edit update destroy ]
  before_action :authorize_user!, only: %i[ edit update destroy ]

  def edit
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @comment.commentable, status: :unprocessable_entity, alert: t('controllers.common.alert_create', name: Comment.model_name.human)
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      redirect_to edit_comment_path(@comment), status: :unprocessable_entity, alert: t('controllers.common.alert_update', name: Comment.model_name.human)
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private
    def set_commentable
      if params[:book_id]
        @commentable = Book.find(params[:book_id])
      elsif params[:report_id]
        @commentable = Report.find(params[:report_id])
      end
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def authorize_user!
      redirect_to root_path, status: :see_other unless @comment.user == current_user
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
