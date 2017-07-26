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
    fill_in 'answer[body]', with: 'My awesome answer'
  end

  scenario 'Authenticated user add file when add answer', js: true do
    attach_file 'answer_attachments_attributes_0_file', "#{Rails.root}/spec/files/test_file_1.txt"
    click_on 'add answer'

    expect(page).to have_content('test_file_1.txt')
  end

  scenario 'Authenticated user add many files when add answer', js: true do
    first_file_field = first('input[type="file"]')
    first_file_field.set "#{Rails.root}/spec/files/test_file_1.txt"

    click_link('+ Add file')

    second_file_field = all('input[type="file"]').last
    second_file_field.set "#{Rails.root}/spec/files/test_file_2.txt"

    click_on 'add answer'

    expect(page).to have_content('test_file_1.txt')
    expect(page).to have_content('test_file_2.txt')
  end
end

