require 'feature_spec_helper'

feature 'Edit question attachments', %q{
  In order to correct my question
  As an question author
  I want to be able to edit attached files
} do


  given(:user)       { create(:user) }
  given(:question)   { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background do
    sign_in(user)
    visit question_path(question)
    click_on('Edit')
  end

  scenario 'User deletes question attachment', js: true do
    expect(page).to have_link('test_image_1.png')

    within first('.nested-fields') do
      find(:css, '#attachment-remove-button').trigger('click')
    end

    click_on('Update question')
    expect(page).to_not have_link('test_image_1.png')
  end

  scenario 'User add one more file', js: true do
    within('.question') do
      click_on('+ Add file')
      file_field = all('input[type="file"]').last
      file_field.set "#{Rails.root}/spec/files/test_file_2.txt"
    end

    click_on('Update question')

    expect(page).to have_link('test_image_1.png')
    expect(page).to have_link('test_file_2.txt')
  end
end