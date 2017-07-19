require 'feature_spec_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Signed in successfully.')
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong-test@test.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Invalid Email or password.')
    expect(current_path).to eq new_user_session_path
  end
end
