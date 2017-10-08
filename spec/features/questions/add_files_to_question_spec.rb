require 'feature_spec_helper'

feature 'Add files to question', %q{
  In order to illustarate my problem
  As a question quthor
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  it_behaves_like 'add attachments ability' do
    let(:path)      { new_question_path }
    let(:container) { '.question' }
    let(:btn)       { 'Create' }

    def fill_form
      data = attributes_for(:question)
      fill_in 'Title', with: data[:title]
      fill_in 'Body',  with: data[:body]
    end
  end
end
