require 'feature_spec_helper'

feature 'Edit question attachments', %q{
  In order to correct my question
  As an question author
  I want to be able to edit attached files
} do

  given(:user)       { create(:user) }
  given(:attachable) { create(:question, user: user) }

  it_should_behave_like 'edit attachments ability' do
    let(:path) { question_path(attachable) }
    let(:trigger_container) { '.question-buttons' }
  end
end
