class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:parent_id] if params[:parent_id].present?

    if @comment.save
      redirect_to @post, notice: 'Comment added successfully.'
    else
      redirect_to @post, alert: 'Failed to add comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
