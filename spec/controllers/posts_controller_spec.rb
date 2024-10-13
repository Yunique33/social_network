require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:valid_attributes) { { title: 'Test Post', body: 'This is a test post.' } }
  let(:new_attributes) { { title: 'Updated Post', body: 'This is an updated test post with enough characters.' } }

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

  context 'with invalid attributes' do
    it 'does not create a new post with a title longer than 80 characters' do
      long_title = 'a' * 81
      expect {
        post :create, params: { post: valid_attributes.merge(title: long_title) }
      }.not_to change(Post, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create a new post with a body shorter than 8 characters' do
      expect {
        post :create, params: { post: valid_attributes.merge(body: 'short') }
      }.not_to change(Post, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create a new post with a body longer than 1000 characters' do
      long_body = 'a' * 1001
      expect {
        post :create, params: { post: valid_attributes.merge(body: long_body) }
      }.not_to change(Post, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create a new post with a duplicate title for the same user' do
      Post.create!(valid_attributes.merge(user: user))
      expect {
        post :create, params: { post: valid_attributes }
      }.not_to change(Post, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #update' do
    let(:post) { Post.create! valid_attributes.merge(user: user) }

    context 'with valid attributes' do
      it 'updates the requested post' do
        patch :update, params: { id: post.to_param, post: new_attributes }
        post.reload
        expect(post.title).to eq('Updated Post')
        expect(post.body).to eq('This is an updated test post with enough characters.')
      end

      it 'redirects to the post' do
        patch :update, params: { id: post.to_param, post: new_attributes }
        expect(response).to redirect_to(post)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the post with a title longer than 80 characters' do
        long_title = 'a' * 81
        patch :update, params: { id: post.to_param, post: { title: long_title } }
        post.reload
        expect(post.title).not_to eq(long_title)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the post with a body shorter than 8 characters' do
        patch :update, params: { id: post.to_param, post: { body: 'short' } }
        post.reload
        expect(post.body).not_to eq('short')
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the post with a body longer than 1000 characters' do
        long_body = 'a' * 1001
        patch :update, params: { id: post.to_param, post: { body: long_body } }
        post.reload
        expect(post.body).not_to eq(long_body)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the post with a duplicate title for the same user' do
        Post.create!(title: 'Existing Post', body: 'This is an existing post.', user: user)
        patch :update, params: { id: post.to_param, post: { title: 'Existing Post' } }
        post.reload
        expect(post.title).not_to eq('Existing Post')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'updates the requested post' do
      patch :update, params: { id: post.to_param, post: new_attributes }
      post.reload
      expect(post.title).to eq('Updated Post')
      expect(post.body).to eq('This is an updated test post with enough characters.')
    end

    it 'redirects to the post' do
      patch :update, params: { id: post.to_param, post: new_attributes }
      expect(response).to redirect_to(post)
    end

    it 'does not update post if user is not the owner' do
      other_user = User.create(email: 'other@example.com', password: 'password')
      other_post = Post.create! valid_attributes.merge(user: other_user)
      patch :update, params: { id: other_post.to_param, post: new_attributes }
      other_post.reload
      expect(other_post.title).not_to eq('Updated Post')
      expect(response).to redirect_to(posts_url)
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

    it 'does not destroy post if user is not the owner' do
      other_user = User.create(email: 'other@example.com', password: 'password')
      other_post = Post.create! valid_attributes.merge(user: other_user)
      expect {
        delete :destroy, params: { id: other_post.to_param }
      }.not_to change(Post, :count)
      expect(response).to redirect_to(posts_url)
    end
  end
end
