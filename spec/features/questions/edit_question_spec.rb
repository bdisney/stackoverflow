require 'feature_spec_helper'

feature 'Edit question', %q{
  In order to correct question
  As a registered user
  I want to be able edit question
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe "Question's author" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      expect(page).to have_selector('.edit-question-link')
    end

    scenario 'updates answer with valid data', js: true do
      click_on('Edit')
      within('.question') do
        fill_in 'Title', with: 'My correct question title'
        fill_in 'Body',  with: 'My correct question body'
        click_on('Update question')

        expect(page).to_not have_content question.body
        expect(page).to have_content('My correct question body')
        expect(page).to_not have_selector('textarea')
      end
    end
  end
end
