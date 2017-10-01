module CommentableSerializer
  extend ActiveSupport::Concern

  included do
    has_many :comments
  end

  def comments
    object.comments.map{ |comment| {id: comment.id, body: comment.body} }
  end
end
