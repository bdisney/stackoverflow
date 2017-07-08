require 'rails_helper'

feature 'View question with or without answers', %q{
  In order to solve my problem
  As a user
  I want to be able to view question with or without answers
} do



  scenario 'View question without answers' do
    question = create(:question)
    visit questions_path
    click_on('Lorem Ipsum')

    expect(current_path).to eq question_path(question)
    expect(page).to have_content('Lorem Ipsum')
    expect(page).to have_content('MyBody')
    expect(page).to_not have_content('Answers')
    expect(page).to have_content('There is no answers yet.')
  end

  scenario 'View question with answers' do
    question = create(:question_with_answers)
    visit question_path(question)

    expect(page).to have_content('Answers')
    expect(page).to have_content('Answer body', count: 2)
  end
end
