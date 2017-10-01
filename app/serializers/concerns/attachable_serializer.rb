module AttachableSerializer
  extend ActiveSupport::Concern

  included do
    has_many :attachments
  end

  def attachments
    object.attachments.map{ |attachment| {id: attachment.id, url: attachment.file.url} }
  end
end
