class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { in: 5..50 }
end
