class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.joins(user: :followers)
                 .where(subscriptions: { follower_id: current_user.id })
                 .order(created_at: :desc)
                 .includes(:user, :comments)
                 .page(params[:page]).per(20)
  end
end