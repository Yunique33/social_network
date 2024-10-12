class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.subscriptions.create(followee: @user)
    redirect_to @user, notice: 'You are now following this user.'
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.subscriptions.find_by(followee: @user).destroy
    redirect_to @user, notice: 'You have unfollowed this user.'
  end
end
