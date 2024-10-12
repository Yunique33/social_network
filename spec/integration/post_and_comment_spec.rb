require 'rails_helper'

RSpec.describe 'Post and Comment integration', type: :request do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }

  before { sign_in user }

  it 'allows creating a post and commenting on it' do
    expect {
      post posts_path, params: { post: { title: 'Test Post', body: 'This is a test post.' } }
    }.to change(Post, :count).by(1)

    expect(response).to have_http_status(:redirect)
    follow_redirect!
    expect(response.body).to include('Test Post')

    post = Post.last
    expect {
      post post_comments_path(post), params: { comment: { body: 'This is a test comment.' } }
    }.to change(Comment, :count).by(1)

    expect(response).to redirect_to(post)
    follow_redirect!
    expect(response.body).to include('This is a test comment.')
  end
end
