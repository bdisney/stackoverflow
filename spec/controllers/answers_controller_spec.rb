require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'voted'

  let!(:question) { create(:question) }
  sign_in_user

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'it saves new answer to db' do
        expect {
          process :create,
                  method: :post,
                  params: {answer: attributes_for(:answer), question_id: question },
                  format: :js
        }.to change(@user.answers.where(question: question), :count).by(1)
      end

      it 'render create template' do
        process :create, method: :post, params: {
          answer: attributes_for(:answer),
          question_id: question
        }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new answer to db' do
        expect {
          process :create, method: :post, params: {
            answer: attributes_for(:invalid_answer),
            question_id: question
          }, format: :js
        }.to_not change(Answer, :count)
      end

      it 're-renders question#show view' do
        process :create, method: :post, params: {
          answer: attributes_for(:invalid_answer), question_id: question
        }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST#destroy' do
    context 'author tries delete his answer' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer from db' do
        expect { process :destroy, method: :post, params: { id: answer }, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'renders destroy tamplate' do
        process :destroy, method: :post, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Someone tries to delete user answer' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      it 'does not delete answer from db' do
        expect { process :destroy, method: :post, params: { id: answer }, format: :js }
          .to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH#update' do
    let(:answer) { create(:answer, question: question, user: @user) }

    context 'with valid attributes' do
      before do
        process :update, method: :patch, params: {
          id: answer, question_id: question, answer: attributes_for(:answer)
        }, format: :js
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        process :update, method: :patch, params: {
          id: answer, answer: { body: 'edited answer' }
        }
        answer.reload
        expect(answer.body).to eq 'edited answer'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        process :update, method: :patch, params: {
            id: answer, question_id: question, answer: { body: nil }
        }, format: :js

        answer.reload
        expect(answer.body).to eq 'Answer body'
      end
    end
  end

  describe 'PATCH#accept' do
    context "accepts answer by question's author" do
      let(:new_question) { create(:question, user: @user) }
      let(:new_answer)   { create(:answer, question: new_question, user: create(:user)) }

      before { process :accept, method: :patch, params: { id: new_answer }, format: :js }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq new_answer
      end

      it 'changes answer accepted attribute' do
        new_answer.reload
        expect(new_answer).to be_accepted
      end

      it 'renders accept template' do
        expect(response).to render_template :accept
      end
    end

    context 'failed to accept by someone else' do
      let(:question) { create(:question) }
      let!(:someones_answer) { create(:answer, question: question) }

      before { process :accept, method: :patch, params: { id: someones_answer }, format: :js }

      it 'dose not accept answer' do
        expect(someones_answer.reload).to_not be_accepted
      end
    end
  end
end
