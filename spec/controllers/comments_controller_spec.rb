require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:post_object) { Post.create(title: 'Test Post', body: 'This is a test post.', user: user) }
  let(:valid_attributes) { { body: 'This is a test comment.' } }

  before { sign_in user }

  describe 'POST #create' do
    it 'creates a new Comment' do
      expect {
        post :create, params: { post_id: post_object.id, comment: valid_attributes }
      }.to change(Comment, :count).by(1)
    end

    it 'redirects to the post' do
      post :create, params: { post_id: post_object.id, comment: valid_attributes }
      expect(response).to redirect_to(post_object)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested comment' do
      comment = Comment.create! valid_attributes.merge(user: user, post: post_object)
      expect {
        delete :destroy, params: { post_id: post_object.id, id: comment.to_param }
      }.to change(Comment, :count).by(-1)
    end

    it 'redirects to the post' do
      comment = Comment.create! valid_attributes.merge(user: user, post: post_object)
      delete :destroy, params: { post_id: post_object.id, id: comment.to_param }
      expect(response).to redirect_to(post_object)
    end
  end
end
