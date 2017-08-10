require 'feature_spec_helper'

feature 'Vote for question', %q{
  In order to show what question was useful or not
  As an authenticated user
  I want to be able
  Vote for it
} do

  given(:user)     { create(:user) }
  given!(:author)  { create(:user) }
  given(:question) { create(:question, user: author) }

  it_should_behave_like 'vote ability' do
    let(:votable)            { create(:question) }
    let!(:votable_path)      { question_path(question) }
    let!(:votable_container) { '.question' }
  end
end
