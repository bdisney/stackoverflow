require 'feature_spec_helper'

feature 'User sign in with social network account', %q{
  In order to ask a question and give answers
  As a user
  I want to sign in with my Facebook or Twitter account
} do

  given(:user) { create(:user) }

  describe 'Facebook' do
    scenario 'New user logs in with facebook' do
      clear_emails
      auth = mock_auth_hash(:facebook)

      visit new_user_session_path
      find("#facebook-link").click

      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'You have to confirm your email address before continuing.')

      open_email(auth[:info][:email])

      current_email.click_link 'Confirm my account'
      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Your email address has been successfully confirmed.')

      visit new_user_session_path
      find("#facebook-link").click

      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Successfully authenticated from facebook account.')
    end

    scenario 'Returning user logs in with facebook' do
      auth = mock_auth_hash(:facebook)
      user.update!(email: 'facebook@test.ru')
      identity = create(:identity, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      find("#facebook-link").click

      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Successfully authenticated from facebook account.')
    end
  end

  describe 'Twitter' do
    scenario 'New user logs in with twitter' do
      clear_emails
      visit new_user_session_path

      mock_auth_hash(:twitter)
      find("#twitter-link").click

      expect(page).to have_content('Add email information')

      fill_in 'auth_hash_info_email', with: 'twitter@test.ru'
      click_on 'Add'

      open_email('twitter@test.ru')

      current_email.click_link 'Confirm my account'
      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Your email address has been successfully confirmed.')

      visit new_user_session_path
      find("#twitter-link").click

      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Successfully authenticated from twitter account.' )
    end

    scenario 'Returning user logs in with twitter' do
      auth = mock_auth_hash(:twitter)
      user.update!(email: 'twitter@test.ru')
      identity = create(:identity, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      find("#twitter-link").click

      expect(page).to have_selector(
                          '#toastr-messages',
                          visible: false,
                          text: 'Successfully authenticated from twitter account.')
    end
  end
end
