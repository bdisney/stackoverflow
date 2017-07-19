require 'feature_spec_helper'

feature 'Delete question', %q{
  In order to cancel my answer
  As an author of it
  I want to be able delete my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  before { sign_in(user) }

  scenario 'deletes by author' do
    visit question_path(question)

    expect(page).to have_content('Answer body')
    expect(page).to have_selector('#delete-answer-button')
    find('#delete-answer-button').click

    expect(page).to_not have_selector('.answer')
    expect(page).to_not have_content('Answer body')
  end

  scenario 'intruder tries delete user answer' do
    question = create(:question)
    create(:answer, question: question)

    visit question_path(question)

    expect(page).to_not have_selector('#delete-answer-button')
  end

  scenario 'Non-authenticated user tries delete answer' do
    logout(:user)

    visit question_path(question)

    expect(page).to_not have_selector('#delete-answer-button')
  end
end
