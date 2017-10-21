require 'feature_spec_helper'

feature "Subscribe user to the question", %q{
  In order to follow answers_mailer for a questions
  As an authenticated user
  I want to be able to subscribe to the question
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user subscribes to the question', js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Subscribe!'

    expect(page).to have_link 'Unsubscribe!'
  end

  scenario 'Authenticated user wants to subscribe to the same question', js: true do
    sign_in(user)
    visit question_path(question)
    click_link 'Subscribe!'

    expect(page).to_not have_link 'Subscribe!'
    expect(page).to have_link 'Unsubscribe!'
  end

  scenario 'Non-Authenticated user tries to subscribe to a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe!'
  end
end
