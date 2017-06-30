class Question < ApplicationRecord
  has_many :answers

  validates :title, :body, presence: true
  validates :title, length: {in: 5..50}
end
