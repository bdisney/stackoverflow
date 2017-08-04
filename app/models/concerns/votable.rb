module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  def has_positive_vote?(user)
    has_vote?(user, 1)
  end

  def has_negative_vote?(user)
    has_vote?(user, -1)
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote(user, value)
    vote = votes.find_or_initialize_by(user: user)
    if vote.persisted? && (vote.value == value)
      vote.destroy
      { success: true, data: { rating: rating } }
    else
      vote.value = value
      return { success: false, errors: vote.errors.full_messages } unless vote.save
      { success: true, data: { rating: rating, vote: vote.value } }
    end
  end

  def has_vote?(user, value)
    votes.exists?(user: user, value: value)
  end
end
