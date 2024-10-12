require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create(email: 'other@example.com', password: 'password') }

  before { sign_in user }

  describe 'POST #follow' do
    it 'creates a new subscription' do
      expect {
        post :follow, params: { id: other_user.id }
      }.to change(Subscription, :count).by(1)
    end

    it 'redirects to the user profile' do
      post :follow, params: { id: other_user.id }
      expect(response).to redirect_to(other_user)
    end
  end

  describe 'DELETE #unfollow' do
    before { user.followees << other_user }

    it 'destroys the subscription' do
      expect {
        delete :unfollow, params: { id: other_user.id }
      }.to change(Subscription, :count).by(-1)
    end

    it 'redirects to the user profile' do
      delete :unfollow, params: { id: other_user.id }
      expect(response).to redirect_to(other_user)
    end
  end
end
