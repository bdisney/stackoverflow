require 'feature_spec_helper'

feature 'User sign in with social network account', %q{
  In order to ask a question and give answers
  As a user
  I want to sign in with my Facebook or Twitter account
} do

  %w(Facebook Twitter).each do |provider|
    describe "User sign in with #{provider}" do
      before do
        visit root_path
        within('.navbar') { click_on 'Log in' }

        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector("##{provider.downcase}-link")
      end

      scenario "when #{provider} account is valid" do
        mock_auth_hash(provider)
        find("##{provider.downcase}-link").click

        expect(page).to have_selector(
          '#toastr-messages',
          visible: false,
          text: "Successfully authenticated from #{provider} account."
        )
      end

      scenario "when #{provider} account is invalid" do
        mock_auth_invalid_hash(provider)
        find("##{provider.downcase}-link").click

        expect(page).to have_selector(
          '#toastr-messages',
          visible: false,
          text: "Could not authenticate you from #{provider} because \"Invalid credentials\"."
        )
      end
    end
  end
end
