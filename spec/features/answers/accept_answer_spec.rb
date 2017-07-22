require 'feature_spec_helper'

feature 'Accept answer', %q{
  In order to show which answer helped me to solve my task
  As a registered user
  I want to be able accept answer
} do

  given!(:author) { create :user }
  given!(:user) { create(:user) }
  given!(:question) { create :question, user: author }
  given!(:answer) { create(:answer, body: 'First answer', question: question) }
  given!(:one_more_answer) { create(:answer, body: 'Second answer', question: question) }

  describe 'Author of question' do
    before do
       page.reset_session!
      sign_in(author)
      visit question_path(question)
    end

    scenario 'sees acceptance links for the answers' do
      expect(page).to have_selector('.accept-answer-link', count: 2)
    end

    scenario 'accept answer', js: true do
      last_answer = question.answers.last

      within("#answer-#{last_answer.id}") do
        find(:css, 'a.accept-answer-link').trigger('click')

        expect(page).to have_selector('.accepted')
        expect(page).to_not have_selector('.not-accepted')
      end

      expect(first('.answer')).to have_content('Second answer')
    end

    scenario 'accept and cancel acceptation', js: true do
      some_answer = question.answers.last
      expect(page).to_not have_selector('.accepted')

      within("#answer-#{some_answer.id}") do
        find(:css, 'a.accept-answer-link').trigger('click')

        expect(page).to have_selector('.accepted')
      end

      find(:css, 'a.accept-answer-link.accepted').trigger('click')

      expect(page).to_not have_selector('.accepted')
    end
  end

  describe "Failed to accept someone's answer by" do
    before { logout(:user) }

    scenario 'authenticated user', js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_selector('a.accept-answer-link')
    end

    scenario 'non-authenticated user', js: true do
      visit question_path(question)

      expect(page).to_not have_selector('a.accept-answer-link')
    end
  end
end
