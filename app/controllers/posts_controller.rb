class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  POSTS_PER_PAGE = 20

  def index
    if user_signed_in?
      @page = [params[:page].to_i, 1].max
      @posts = current_user.posts
                           .order(created_at: :desc)
                           .offset((@page - 1) * POSTS_PER_PAGE)
                           .limit(POSTS_PER_PAGE)
      @total_pages = (current_user.posts.count.to_f / POSTS_PER_PAGE).ceil
    else
      redirect_to new_user_session_path
    end
  end

  def show
    if authorized_to_view_post?
      render :show
    else
      redirect_to new_user_session_path, alert: "You need to sign in or follow the user to view this post."
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def authorized_to_view_post?
    @post.user == current_user || (user_signed_in? && current_user.following?(@post.user))
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_owner
    unless @post && @post.user == current_user
      redirect_to posts_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
