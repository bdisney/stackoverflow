require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:accepted).scoped_to(:question_id) }

  describe 'accept' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer)   { create(:answer, question: question) }

    it "toggling answer's accepted attribute" do
      answer.accept
      expect(answer.reload).to be_accepted

      answer.accept
      expect(answer.reload).to_not be_accepted
    end
  end
end
