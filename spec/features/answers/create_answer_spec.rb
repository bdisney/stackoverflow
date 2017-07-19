require 'rails_helper'

feature 'Create answer', %q{
  In order to help with question
  As a registered user
  I want to be able add answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your awesome answer:', with: 'Some text'
    click_on('add answer')

    expect(current_path).to eq question_path(question)
    expect(page).to have_selector('.toast-success',
                                  visible: false,
                                  text: 'Answer was created.')
    expect(page).to have_content('Some text')

  end

  scenario 'Authenticated user tries create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer[body]', with: ''
    click_on('add answer')

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Body can&#39;t be blank")
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user wants to create answer' do
    visit question_path(question)

    expect(page).to_not have_content('Add new answer:')
    expect(page).to have_content('You should log in or sign up to answer this question.')
  end
end
