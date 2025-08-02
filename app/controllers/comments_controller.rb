class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ edit update destroy ]

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to comment_url(@comment), notice: "Comment was successfully created."
    else
      render :new, status: :unprocessable_entity
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
    redirect_to comments_url, notice: "Comment was successfully destroyed."
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
