# frozen_string_literal: true

class CommentsController < ApplicationController
  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def create
    commentable = find_commentable
    comment = commentable.comments.build(comment_params.merge(user: current_user))

    if comment.save
      redirect_to comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to comment.commentable, status: :unprocessable_entity, alert: t('controllers.common.alert_create', name: Comment.model_name.human)
    end
  end

  def update
    comment = current_user.comments.find(params[:id])

    if comment.update(comment_params)
      redirect_to comment.commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      redirect_to edit_comment_path(comment), status: :unprocessable_entity, alert: t('controllers.common.alert_update', name: Comment.model_name.human)
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])

    comment.destroy
    redirect_to comment.commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def find_commentable
    if params[:book_id]
      Book.find(params[:book_id])
    elsif params[:report_id]
      Report.find(params[:report_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
