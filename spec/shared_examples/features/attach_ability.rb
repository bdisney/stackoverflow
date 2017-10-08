shared_examples_for 'add attachments ability' do
  background do
    sign_in(user)
    visit path
  end

  scenario 'Authenticated user creates record with attachments', js: true do
    fill_form

    first_file_field = first('input[type="file"]')
    first_file_field.set "#{Rails.root}/spec/files/test_file_1.txt"

    click_link('+ Add file')

    second_file_field = all('input[type="file"]').last
    second_file_field.set "#{Rails.root}/spec/files/test_file_2.txt"

    click_on btn

    within container do
      expect(page).to have_content('test_file_1.txt')
      expect(page).to have_content('test_file_2.txt')
    end
  end
end

shared_examples_for 'edit attachments ability' do
  let!(:attachment) { create(:attachment, attachable: attachable) }
  let!(:attachable_name) { attachable.class.to_s.underscore }

  background do
    sign_in(user)
    visit path
    within trigger_container do
      click_on 'Edit'
    end
  end

  scenario 'Author removes attachment', js: true do
    within ".#{attachable_name}" do
      expect(page).to have_link(('test_image_1.png'))

      within first('.nested-fields') do
        find(:css, '#attachment-remove-button').trigger('click')
      end
      click_on('Update')
      sleep 2
      expect(page).to_not have_link('test_image_1.png')
    end
  end

  scenario 'Author attach additional file', js: true do
    within ".#{attachable_name}" do
      click_on('+ Add file')
      file_field = all('input[type="file"]').last
      file_field.set "#{Rails.root}/spec/files/test_file_2.txt"
      click_on('Update')

      expect(page).to have_link('test_image_1.png')
      expect(page).to have_link('test_file_2.txt')
    end
  end
end
