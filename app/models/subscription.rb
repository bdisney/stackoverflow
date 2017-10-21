class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question, required: true

  validates :question_id, uniqueness: { scope: :user_id }
end
