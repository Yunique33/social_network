require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:valid_attributes) { { title: 'Test Post', body: 'This is a test post.' } }

  before { sign_in user }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      post = Post.create! valid_attributes.merge(user: user)
      get :show, params: { id: post.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new Post' do
      expect {
        post :create, params: { post: valid_attributes }
      }.to change(Post, :count).by(1)
    end

    it 'redirects to the created post' do
      post :create, params: { post: valid_attributes }
      expect(response).to redirect_to(Post.last)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested post' do
      post = Post.create! valid_attributes.merge(user: user)
      expect {
        delete :destroy, params: { id: post.to_param }
      }.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts list' do
      post = Post.create! valid_attributes.merge(user: user)
      delete :destroy, params: { id: post.to_param }
      expect(response).to redirect_to(posts_url)
    end
  end
end
