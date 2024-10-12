class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @posts = visible_posts_for(@user)
  end

  def index
    @users = User.all
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    redirect_to @user, notice: 'You are now following this user.'
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followees.delete(@user)
    redirect_to @user, notice: 'You have unfollowed this user.'
  end

  private

  def visible_posts_for(user)
    if user_signed_in?
      return user.posts.order(created_at: :desc) if user == current_user || current_user.following?(user)
    end
    user.posts.none
  end
end
