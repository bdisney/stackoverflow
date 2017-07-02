require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }


    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

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
        }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        process :create, method: :post, params: {
          answer: attributes_for(:invalid_answer), question_id: question
        }
        expect(response).to render_template :new
      end
    end
  end
end