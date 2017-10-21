require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  it_behaves_like 'attachable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(100) }

  describe 'subscribe author after create' do
    let(:question) { build(:question) }

    it 'calls subscribe_author after create' do
      expect(question).to receive(:subscribe_author)
      question.save
    end

    it 'creates subscription for author after question creation' do
      expect(Subscription).to receive(:create!).with({ user: question.user, question: question })
      question.save
    end
  end
end
