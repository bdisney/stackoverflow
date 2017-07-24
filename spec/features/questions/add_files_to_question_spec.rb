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
  end

  scenario 'User add file when create question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    attach_file 'File', "#{Rails.root}/spec/files/test_file_1.txt"
    click_on 'Create'

    expect(page).to have_content('test_file_1.txt')
  end
end