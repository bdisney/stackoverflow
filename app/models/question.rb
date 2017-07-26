class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { in: 10..100 }

  accepts_nested_attributes_for :attachments,
                                reject_if: proc { |attributes| attributes['file'].blank? },
                                allow_destroy: true
end
