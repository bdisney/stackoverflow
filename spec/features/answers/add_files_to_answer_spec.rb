require 'feature_spec_helper'

feature 'Add files to answer', %q{
  In order to illustrate my problem
  As a answer author
  I want to be able to attach files
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user add file when add answer', js: true do
    fill_in 'answer[body]', with: 'My awesome answer'
    attach_file 'File', "#{Rails.root}/spec/files/test_file_1.txt"
    click_on 'add answer'

    expect(page).to have_content('test_file_1.txt')
  end
end