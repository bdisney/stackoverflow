require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'when guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'when admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'when authenticated user' do
    let(:user) { create(:user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context 'with question' do
      it { should be_able_to :create, Question }

      context 'if author' do
        let!(:question) { create(:question, user: user) }

        it { should be_able_to :manage_own, question }
        it { should_not be_able_to :vote, question }

        let!(:answer) { create(:answer, question: question) }

        it { should be_able_to :accept, answer }
      end

      context 'if not an author' do
        let!(:others_question) { create(:question) }

        it { should_not be_able_to :manage_own, others_question }
        it { should be_able_to :vote, others_question }

        let!(:answer) { create(:answer, question: others_question) }

        it { should_not be_able_to :accept, answer }
      end
    end

    context 'with answer' do
      it { should be_able_to :create, Answer }

      context 'if author' do
        let!(:answer) { create(:answer, user: user) }

        it { should be_able_to :manage_own, answer }
        it { should_not be_able_to :vote, answer }
      end

      context 'if not an author' do
        let!(:others_answer) { create(:answer) }

        it { should_not be_able_to :manage_own, others_answer }
        it { should be_able_to :vote, others_answer }
      end
    end

    context 'with comment' do
      let!(:comment) { create(:comment, user: user) }
      let!(:others_comment) { create(:comment) }

      it { should be_able_to :create, Comment }

      it { should be_able_to :destroy, comment }
      it { should_not be_able_to :destroy, others_comment }
    end
  end
end
