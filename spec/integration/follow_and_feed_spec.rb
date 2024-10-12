require 'rails_helper'

RSpec.describe 'Follow and Feed integration', type: :request do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:other_user) { User.create(email: 'other@example.com', password: 'password') }

  before { sign_in user }

  it 'allows following a user and seeing their posts in the feed' do
    post follow_user_path(other_user)
    expect(response).to redirect_to(other_user)

    Post.create(title: 'Other User Post', body: 'This is a post by the other user.', user: other_user)

    get feed_path
    expect(response.body).to include('Other User Post')

    delete unfollow_user_path(other_user)
    expect(response).to redirect_to(other_user)

    get feed_path
    expect(response.body).not_to include('Other User Post')
  end
end
