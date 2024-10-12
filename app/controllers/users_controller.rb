class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
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
end
