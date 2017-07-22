class Answer < ApplicationRecord
  default_scope { order(accepted: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :accepted, uniqueness: { scope: :question_id }, if: :accepted

  def accept
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      toggle(:accepted).save!
    end
  end
end
