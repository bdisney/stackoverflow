class Question < ApplicationRecord
  default_scope { order(created_at: :desc) }

  include Votable
  include Commentable
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { in: 10..100 }

  after_create :subscribe_author

  def subscribe_author
    Subscription.create!(user: user, question: self)
  end
end
