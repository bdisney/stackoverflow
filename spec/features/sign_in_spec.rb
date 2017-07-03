require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do
  scenario 'Registered user trying to sign in' do
    User.create!(email: 'test@test.com', password: '123456')

    visit new_user_session_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false, text: 'Signed in successfully.')
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user trying to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong-test@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false, text: 'Invalid Email or password.')
    expect(current_path).to eq new_user_session_path
  end
end
