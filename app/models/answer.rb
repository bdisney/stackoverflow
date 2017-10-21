class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Attachable

  default_scope { order(accepted: :desc, created_at: :asc) }

  after_create :notify_subscribers

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

  def notify_subscribers
    NotifySubscribersJob.perform_later(self)
  end
end
