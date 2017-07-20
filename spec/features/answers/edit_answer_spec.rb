require 'feature_spec_helper'

feature 'Edit answer', %q{
  In order to correct answer
  As a registered user
  I want to be able edit answer
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_selector('#edit-answer-button')
  end

  describe "Answer's author" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit' do
      within '.answers-list' do
        expect(page).to have_selector('.edit-answer-link')
      end
    end

    scenario 'updates answer with valid data', js: true do
      click_on('Edit')
      within('.answers-list') do
        fill_in 'Your answer:', with: 'My correct answer'
        click_on('Update answer')

        expect(page).to_not have_content answer.body
        expect(page).to have_content('My correct answer')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'updates answer with invalid data', js: true do
      click_on('Edit')
      fill_in 'Your answer:', with: nil
      click_on('Update answer')

      expect(page).to have_selector('#toastr-errors',
                                    visible: false,
                                    text: "Body can&#39;t be blank")
      expect(page).to have_selector('#answer_body')
      expect(answer.body).to_not be_nil
    end
  end

  scenario "Authenticated user tries edit other user's answer", js: true do
    user = create(:user)
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_selector('.edit-answer-link')
  end
end
