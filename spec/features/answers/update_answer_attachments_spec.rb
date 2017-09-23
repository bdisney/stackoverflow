require 'feature_spec_helper'

feature 'Edit answer attachments', %q{
  In order to correct my answer
  As an answer author
  I want to be able to edit attached files
} do

  given(:user)        { create(:user) }
  given(:question)    { create(:question, user: user) }
  given!(:answer)     { create(:answer, question: question, user_id: user.id) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
    within('.answers-list') do
      click_on('Edit')
    end
  end

  scenario 'User deletes answer attachment', js: true do
    expect(page).to have_link('test_image_1.png')

    within first('.nested-fields') do
      find(:css, '#attachment-remove-button').trigger('click')
    end

    click_on('Update answer')
    sleep 2
    expect(page).to_not have_link('test_image_1.png')
  end

  scenario 'User add one more file', js: true do
    within('.answer') do
      click_on('+ Add file')
      file_field = all('input[type="file"]').last
      file_field.set "#{Rails.root}/spec/files/test_file_2.txt"
    end

    click_on('Update answer')
    expect(page).to have_link('test_image_1.png')
    expect(page).to have_link('test_file_2.txt')
  end
end