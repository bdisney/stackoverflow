require 'feature_spec_helper'

feature 'User sign out', %q{
  In order to destroy my session
  As an authenticated user
  I want to be able sign out
} do

  given(:user) { create(:user) }

  scenario 'User tries to sign out' do
    sign_in(user)
    click_link('Log out')

    expect(current_path).to eq root_path
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Signed out successfully.')
  end
end