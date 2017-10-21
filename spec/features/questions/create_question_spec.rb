require 'feature_spec_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'Question was created.')
    expect(page).to have_link 'Unsubscribe!'
    expect(page).to have_content('Test question')
    expect(page).to have_content('Test body')
  end

  scenario 'Authenticated user tries create question with invalid data' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    invalid_data = attributes_for(:invalid_question)

    fill_in 'Title', with: invalid_data[:title]
    fill_in 'Body', with: invalid_data[:body]

    click_on 'Create'

    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Body can&#39;t be blank")
    expect(page).to have_selector('#toastr-errors',
                                  visible: false,
                                  text: "Title can&#39;t be blank")
    expect(current_path).to eq questions_path
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('quest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test body'
        click_on 'Create'

        expect(page).to have_selector('#toastr-messages',
                                      visible: false,
                                      text: 'Question was created.')
        expect(page).to have_content('Test question')
        expect(page).to have_content('Test body')
      end

      Capybara.using_session('quest') do
        wait_for_ajax
        expect(page).to have_content('Test question')
        expect(page).to have_content('Test body')
      end
    end
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_selector('#toastr-messages',
                                  visible: false,
                                  text: 'You need to sign in or sign up before continuing.')
  end
end
