RSpec.describe FeedController, type: :request do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:followed_user) { User.create(email: 'followed@example.com', password: 'password') }
  let(:unfollowed_user) { User.create(email: 'unfollowed@example.com', password: 'password') }

  before do
    sign_in user
    user.followees << followed_user
    Post.create(title: 'User Post', body: 'Own post', user: user)
    Post.create(title: 'Followed Post', body: 'Followed user post', user: followed_user)
    Post.create(title: 'Unfollowed Post', body: 'Unfollowed user post', user: unfollowed_user)
  end

  describe "GET /feed" do
    it "includes user's own posts and posts from followed users" do
      get feed_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('User Post', 'Followed Post')
      expect(response.body).not_to include('Unfollowed Post')
    end

    it "paginates results" do
      (FeedController::POSTS_PER_PAGE + 1).times do |i|
        Post.create(title: "Extra Post #{i}", body: "Extra content", user: followed_user)
      end

      get feed_path
      expect(response.body).to include('Next')

      get feed_path(page: 2)
      expect(response.body).to include('Extra Post')
    end
  end
end
