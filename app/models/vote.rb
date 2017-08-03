class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :value, inclusion: [1, -1]

  validate :oneself_voting

  private

  def oneself_voting
    errors.add(:user_id, "You can't vote for your #{votable_type}") if votable && user_id == votable.user_id
  end
end