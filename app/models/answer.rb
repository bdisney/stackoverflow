class Answer < ApplicationRecord
  default_scope { order(accepted: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :body, presence: true
  validates :accepted, uniqueness: { scope: :question_id }, if: :accepted

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true

  def accept
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      toggle(:accepted).save!
    end
  end
end
