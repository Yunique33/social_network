class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, foreign_key: :follower_id, dependent: :destroy
  has_many :followees, through: :subscriptions, source: :followee
  has_many :reverse_subscriptions, foreign_key: :followee_id, class_name: 'Subscription', dependent: :destroy
  has_many :followers, through: :reverse_subscriptions, source: :follower

  def following?(other_user)
    followees.include?(other_user)
  end
end
