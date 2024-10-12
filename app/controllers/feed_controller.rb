class FeedController < ApplicationController
  before_action :authenticate_user!

  POSTS_PER_PAGE = 20

  def index
    @page = current_page
    @posts = fetch_posts
    @total_pages = calculate_total_pages
  end

  private

  def current_page
    [params[:page].to_i, 1].max
  end

  def fetch_posts
    filtered_posts
      .order(created_at: :desc)
      .includes(:user, :comments)
      .distinct
      .offset((@page - 1) * POSTS_PER_PAGE)
      .limit(POSTS_PER_PAGE)
  end

  def calculate_total_pages
    total_posts = filtered_posts.distinct.count
    (total_posts.to_f / POSTS_PER_PAGE).ceil
  end

  def filtered_posts
    Post.left_joins(user: :followers)
        .where("subscriptions.follower_id = :user_id OR posts.user_id = :user_id", user_id: current_user.id)
  end
end
