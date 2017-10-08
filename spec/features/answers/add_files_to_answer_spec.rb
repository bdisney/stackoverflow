require 'feature_spec_helper'

feature 'Add files to answer', %q{
  In order to illustrate my problem
  As a answer author
  I want to be able to attach files
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  it_behaves_like 'add attachments ability' do
    let(:path)      { question_path(question) }
    let(:container) { '.answers-list' }
    let(:btn)       { 'add answer' }

    def fill_form
      data = attributes_for(:answer)
      fill_in 'answer[body]', with: data[:body]
    end
  end
end
