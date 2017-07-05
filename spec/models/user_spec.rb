require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'check what user can manage resource' do
    user = create(:user)
    question = create(:question, user: user)

    expect(user.can_can_can_manage?(question)).to eq question.user == user
  end
end
