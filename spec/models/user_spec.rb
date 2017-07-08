require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User tries to manage resource' do
    let(:user) { create(:user) }

    it 'returns true if user is author of resource' do
      question = create(:question, user: user)

      expect(user).to be_author_of(question)
    end

    it 'returns false if user is not author of resource' do
      question = create(:question, user: create(:user))

      expect(user).to_not be_author_of(question)
    end
  end
end
