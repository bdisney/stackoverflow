shared_examples_for 'add comment ability' do
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit commentable_path
      # save_and_open_page
    end

    scenario 'can see add_comment link' do
      within commentable_container do
        expect(page).to have_link('+Add comment')
      end
    end

    scenario 'can add comment to resource with valid data', js: true do
      within commentable_container do
        click_on '+Add comment'

        fill_in 'Your comment', with: 'Comment body'
        click_on 'Add comment'

        within('.comments-list') do
          expect(page).to have_content('Comment body')
        end
      end
    end

    scenario 'tries add comment with invalid data', js: true do
      within commentable_container do
        click_on '+Add comment'

        fill_in 'Your comment', with: ''
        click_on 'Add comment'
      end
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Non-authenticated user tries add comment' do
    visit commentable_path

    expect(page).to_not have_link('+Add link')
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within commentable_container do
          click_on '+Add comment'
          fill_in 'Your comment', with: 'My awesome comment'
          click_on 'Add comment'
        end

        expect(page).to have_content('My awesome comment')
      end

      Capybara.using_session('quest') do
        wait_for_ajax
        expect(page).to have_content('My awesome comment')
      end
    end
  end
end
