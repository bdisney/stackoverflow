require 'feature_spec_helper'

feature 'Add files to question', %q{
  In order to illustarate my problem
  As a question quthor
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
  end

  scenario 'User add file when create question' do
    within('.nested-fields') do
      file_field = first('input[type="file"]')
      file_field.set "#{Rails.root}/spec/files/test_file_1.txt"
    end

    click_on 'Create'
    expect(page).to have_content('test_file_1.txt')
  end

  scenario 'User add many files when create question', js: true do
    first_file_field = first('input[type="file"]')
    first_file_field.set "#{Rails.root}/spec/files/test_file_1.txt"

    click_link('+ Add file')

    second_file_field = all('input[type="file"]').last
    second_file_field.set "#{Rails.root}/spec/files/test_file_2.txt"

    click_on 'Create'

    expect(page).to have_content('test_file_1.txt')
    expect(page).to have_content('test_file_2.txt')
  end
end
