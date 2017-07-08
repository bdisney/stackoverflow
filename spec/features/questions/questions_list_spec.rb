require 'rails_helper'

feature 'Display list of questions', %q{
  In order to keep abreast of all matters
  As a user i want to be able
  I want to be able view questions list
} do

  scenario 'User views the list of questions' do
    create_list(:question, 5)

    visit questions_path

    expect(page).to have_content('Lorem Ipsum', count: 5)
    expect(page).to have_content('MyBody', count: 5)
  end
end
