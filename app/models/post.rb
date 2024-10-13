class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true,
            length: { maximum: 80 },
            uniqueness: { scope: :user_id, message: "You already have a post with this title" }

  validates :body, presence: true,
            length: { in: 8..1000 }
end
