require 'feature_spec_helper'

feature 'User sign up', %q{
  In order to be able to ask question and add answers
  As an user
  I want to sign up
} do

  scenario 'Non-registered user tries to sign up with valid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
    expect(current_path).to eq root_path

    open_email('test@test.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_selector(
                        '#toastr-messages',
                        visible: false,
                        text: 'Your email address has been successfully confirmed.')
  end

  scenario 'Non-registered user tries to sign up with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'wrong-email@test.com'
    fill_in 'Password', with: ''
    click_button 'Sign up'

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Password can&#39;t be blank")
  end
end