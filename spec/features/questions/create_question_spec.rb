require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Question was created.')
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'You need to sign in or sign up before continuing.')
  end
end
