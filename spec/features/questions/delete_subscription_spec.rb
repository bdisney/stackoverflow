require 'feature_spec_helper'

feature "Unsubscribe User from the subscribed question", %q{
  In order to stop following answers_mailer for a questions
  As an authenticated user
  I want to be able to unsubscribe from the question
} do

  given(:user)          { create(:user) }
  given!(:question)     { create(:question) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated user subscribes to the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Unsubscribe!'

    expect(page).to have_content 'Unsubscribed!'
    expect(page).to have_link 'Subscribe!'
  end

  scenario 'Authenticated user wants to unsubscribe from the same question', js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Unsubscribe!'

    expect(page).to_not have_link 'Unsubscribe!'
  end

  scenario 'Non-Authenticated user tries to unsubscribe from a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Unsubscribe!'
  end
end
