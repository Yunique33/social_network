require 'rails_helper'

RSpec.describe 'Post visibility and Feed functionality', type: :request do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create(email: 'other@example.com', password: 'password') }
  let(:followed_user) { User.create(email: 'followed@example.com', password: 'password') }

  before do
    Post.create(title: 'User Post', body: 'Post by user', user: user)
    Post.create(title: 'Other User Post', body: 'Post by other user', user: other_user)
    Post.create(title: 'Followed User Post', body: 'Post by followed user', user: followed_user)
  end

  context 'when user is not signed in' do
    it 'can see the index of posts but not individual posts' do
      get post_path(Post.first)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq("You need to sign in or follow the user to view this post.")
    end

    it 'can see user profiles but not their posts' do
      get user_path(user)
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include('Post by user')
    end
  end

  context 'when user is signed in' do
    before { sign_in user }

    it 'can see own posts' do
      get post_path(Post.find_by(title: 'User Post'))
      expect(response).to have_http_status(:success)
      expect(response.body).to include('User Post')
    end

    it 'cannot see posts of unfollowed users' do
      get post_path(Post.find_by(title: 'Other User Post'))
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq("You need to sign in or follow the user to view this post.")
    end

    it 'can see posts of followed users' do
      user.followees << followed_user
      get post_path(Post.find_by(title: 'Followed User Post'))
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Followed User Post')
    end

    it 'shows only own and followed users posts in feed' do
      user.followees << followed_user
      get feed_path
      expect(response.body).to include('User Post', 'Followed User Post')
      expect(response.body).not_to include('Other User Post')
    end
  end
end
