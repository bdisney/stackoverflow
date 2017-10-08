require 'feature_spec_helper'

feature 'Edit answer attachments', %q{
  In order to correct my answer
  As an answer author
  I want to be able to edit attached files
} do

  given(:user)        { create(:user) }
  given(:question)    { create(:question, user: user) }
  given(:attachable)  { create(:answer, question: question, user: user) }

  it_should_behave_like 'edit attachments ability' do
    let(:path) { question_path(question) }
    let(:trigger_container) { '.answers-list' }
  end
end
