require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'it saves new answer to db' do
        expect { process :create, method: :post, params: {answer: attributes_for(:answer), question_id: question }}
            .to change(question.answers, :count).by(1)
      end

      it 'redirects to @question' do
        process :create, method: :post, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect {
          process :create, method: :post, params: {
            answer: attributes_for(:invalid_answer),
            question_id: question
          }
        }.to_not change(Answer, :count)
      end

      it 're-renders question#show view' do
        process :create, method: :post, params: {
          answer: attributes_for(:invalid_answer), question_id: question
        }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end