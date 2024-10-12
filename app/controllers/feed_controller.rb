class FeedController < ApplicationController
  before_action :authenticate_user!

  POSTS_PER_PAGE = 20

  def index
    @page = [params[:page].to_i, 1].max

    @posts = Post.joins(user: :followers)
                 .where(subscriptions: { follower_id: current_user.id })
                 .order(created_at: :desc)
                 .includes(:user, :comments)
                 .offset((@page - 1) * POSTS_PER_PAGE)
                 .limit(POSTS_PER_PAGE)

    @total_pages = (Post.joins(user: :followers)
                        .where(subscriptions: { follower_id: current_user.id })
                        .count.to_f / POSTS_PER_PAGE).ceil
  end
end