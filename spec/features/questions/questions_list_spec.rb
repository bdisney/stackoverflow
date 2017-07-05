require 'rails_helper'

feature 'Display list of questions', %q{
  In order to keep abreast of all matters
  As a user i want to be able
  I want to be able view questions list
} do

  scenario 'User views the list of questions' do
    5.times { create(:question) }
    visit questions_path

    expect(page).to have_content('MyTitle', count: 5)
    expect(page).to have_content('MyBody', count: 5)
  end
end
