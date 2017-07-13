require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'it saves new answer to db' do
        expect { process :create, method: :post, params: {answer: attributes_for(:answer), question_id: question} }
            .to change(@user.answers.where(question: question), :count).by(1)
      end

      it 'redirects to @question' do
        process :create, method: :post, params: {
          answer: attributes_for(:answer),
          question_id: question
        }
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

  describe 'POST#destroy' do
    sign_in_user

    context 'author tries delete his answer' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer from db' do
        expect { process :destroy, method: :post, params: { id: answer } }
          .to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        process :destroy, method: :post, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Someone tries to delete user answer' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      it 'does not deletes answer from db' do
        expect { process :destroy, method: :post, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'redirects to question page' do
        process :destroy, method: :post, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
