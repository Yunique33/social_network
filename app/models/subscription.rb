class Subscription < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followee_id }
  validate :not_self_subscription

  private

  def not_self_subscription
    errors.add(:base, "Cannot subscribe to yourself") if follower_id == followee_id
  end
end