require 'rails_helper'

feature 'Create answer', %q{
  In order to help with question
  As a registered user
  I want to be able add answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer[body]', with: 'Some text'
    click_on('add answer')

    expect(current_path).to eq question_path(question)
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Answer was created.')
  end

  scenario 'Non-authenticated user want to creates answer' do
    visit question_path(question)

    expect(page).to_not have_content('Add new answer:')
    expect(page).to have_content('You should log in or sign up to answer this question.')
  end

end