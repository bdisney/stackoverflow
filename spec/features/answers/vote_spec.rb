require 'feature_spec_helper'

feature 'Vote for answer', %q{
  In order to show what answer was useful or not
  As an authenticated user
  I want to be able
  Vote for it
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:author)  { create(:user) }
  given!(:answer)  { create(:answer, question: question, user: author) }
  
  it_should_behave_like 'vote ability' do
    let(:votable)            { create(:answer, question: question) }
    let!(:votable_path)      { question_path(question) }
    let!(:votable_container) { '.answers-list' }
  end
end
