require 'feature_spec_helper'

feature 'Delete question', %q{
  In order to cancel my question
  As an author of the question
  I want to be able delete my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author of question delete it' do
    sign_in(user)
    visit question_path(question)

    click_on('Delete')

    expect(current_path).to eq questions_path
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Question was deleted.')
    expect(page).to_not have_content(question.title)
    expect(page).to_not have_content(question.body)
  end

  scenario 'Intruder tries to delete it' do
    sign_in(user)
    random_question = create(:question)

    visit question_path(random_question)
    expect(page).to_not have_button('Delete')
  end

  scenario 'Non-authenticated user tries delete question' do
    visit question_path(question)

    expect(page).to_not have_button('Delete')
  end
end
