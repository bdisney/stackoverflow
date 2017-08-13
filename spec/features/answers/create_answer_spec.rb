require 'feature_spec_helper'

feature 'Create answer', %q{
  In order to help with question
  As a registered user
  I want to be able add answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer[body]', with: 'Some text'
    click_on('add answer')

    expect(current_path).to eq question_path(question)
    expect(page).to have_selector('.toast-success',
                                  visible: false,
                                  text: 'Answer was created.')
    expect(page).to have_content('1 answer')
    expect(page).to have_content('Some text')

  end

  scenario 'Authenticated user tries create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'answer[body]', with: ''
    click_on('add answer')

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Body can&#39;t be blank")
    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content('1 answer')
    expect(page).to have_content('There is no answers yet.')
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'My awesome answer'
        click_on 'add answer'

        expect(page).to have_content('My awesome answer')
      end

      Capybara.using_session('quest') do
        wait_for_ajax
        expect(page).to have_content('My awesome answer')
      end
    end
  end

  scenario 'Non-authenticated user wants to create answer' do
    visit question_path(question)

    expect(page).to_not have_content('Add new answer:')
    expect(page).to have_content('You should log in or sign up to answer this question.')
  end
end
