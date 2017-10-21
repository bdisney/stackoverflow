require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let!(:subscription) { create(:subscription) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }
end
