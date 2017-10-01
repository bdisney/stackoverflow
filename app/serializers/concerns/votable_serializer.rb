module VotableSerializer
  extend ActiveSupport::Concern

  included do
    attributes :rating
  end

  def rating
    object.votes.sum(:value)
  end
end
