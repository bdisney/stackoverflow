module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachments, dependent: :destroy, as: :attachable

    accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes['file'].blank? },
                                  allow_destroy: true
  end
end
