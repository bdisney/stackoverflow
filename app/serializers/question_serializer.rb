class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  include CommentableSerializer
  include AttachableSerializer
  include VotableSerializer

  has_many :answers
end
