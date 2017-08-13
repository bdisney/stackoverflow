require 'feature_spec_helper'

feature 'Add comment to answer', %q{
  In order to clarify answer
  As an authenticated user
  I want to be able
  Add comments to answer
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)  { create(:answer, question: question) }

  it_should_behave_like 'comment ability' do
    let(:commentable)            { answer }
    let!(:commentable_path)      { question_path(question) }
    let!(:commentable_container) { '.answer' }
  end
end
