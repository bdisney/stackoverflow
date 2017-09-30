class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  include CommentableSerializer
  include AttachableSerializer
  include VotableSerializer
end
