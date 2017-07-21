class Answer < ApplicationRecord
  default_scope { order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
end
