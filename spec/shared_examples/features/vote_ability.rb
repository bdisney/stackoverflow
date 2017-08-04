shared_examples_for 'vote ability' do
  describe 'Authenticated user' do
    before do
      logout(:user)
      sign_in(user)
      visit votable_path
    end

    scenario 'User sees vote links', js: true do
      within(votable_container) do
        expect(page).to have_selector('.vote-up')
        expect(page).to have_selector('.rating')
        expect(page).to have_selector('.vote-down')
      end
    end

    scenario "User votes for the object", js: true do
      within(votable_container) do
        find(:css, '.vote-up').trigger('click')
        within('.rating') do
          expect(page).to have_content('1')
        end
      end
    end

    scenario 'User votes against the object', js: true do
      within(votable_container) do
        find(:css, '.vote-down').trigger('click')
        within('.rating') do
          expect(page).to have_content('-1')
        end
      end
    end

    scenario 'User cancel his vote', js: true do
      within(votable_container) do
        find(:css, '.vote-up').trigger('click')
        within('.rating') do
          expect(page).to have_content('1')
        end

        find(:css, '.vote-up').trigger('click')
        within('.rating') do
          expect(page).to have_content('0')
        end
      end
    end

    scenario 'Author of object does not see vote links' do
      logout(:user)
      sign_in(author)
      visit question_path(question)

      within(votable_container) do
        expect(page).to_not have_selector('.vote-up')
        expect(page).to have_selector('.rating')
        expect(page).to_not have_selector('.vote-down')
      end
    end

    scenario 'Non-authenticated user does not see vote links' do
      logout(:user)
      visit question_path(question)

      within(votable_container) do
        expect(page).to_not have_selector('.vote-up')
        expect(page).to have_selector('.rating')
        expect(page).to_not have_selector('.vote-down')
      end
    end
  end
end
