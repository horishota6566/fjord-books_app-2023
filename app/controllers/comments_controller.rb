class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]
  before_action :set_comment, only: %i[ edit update destroy ]

  def edit
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @comment.commentable, notice: "Comment was successfully created."
    else
      redirect_to @comment.commentable, status: :unprocessable_entity, alert: "Comment could not be created."
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to comment_url(@comment), notice: "Comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: "Comment was successfully destroyed."
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

    def comment_params
      params.require(:comment).permit(:content)
    end
end
