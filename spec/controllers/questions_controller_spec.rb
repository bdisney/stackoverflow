require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns new attachment for @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves new question in the database' do
        expect { process :create, method: :post, params: { question: attributes_for(:question) } }
          .to change(@user.questions, :count).by(1)
      end
      it 'redirects to show view' do
        process :create, method: :post, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question to db' do
        expect { process :create, method: :post, params: { question: attributes_for(:invalid_question) } }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        process :create, method: :post, params: {
          question: attributes_for(:invalid_question)
        }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      let(:question) { create(:question, user: @user) }

      before do
        process :update, method: :patch, params: {
          id: question, question: attributes_for(:question)
        }, format: :js
      end

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        process :update, method: :patch, params: {
          id: question, question: {title: 'Question new title', body: 'Question new body' }
        }, format: :js

        question.reload

        expect(question.title).to eq 'Question new title'
        expect(question.body).to eq 'Question new body'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question attributes' do
        process :update, method: :patch, params: {
          id: question, question: {title: 'Title for invalid question', body: nil }
        }, format: :js

        question.reload

        expect(question.title).to eq 'Lorem Ipsum'
        expect(question.body).to eq 'MyBody'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'delete by author' do
      let!(:question) { create(:question, user: @user) }

      it 'deletes question' do
        expect { process :destroy, method: :delete, params: { id: question } }
            .to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete by intruder' do
      let!(:question) { create(:question) }

      it 'does not delete question from db' do
        expect { process :destroy, method: :delete, params: { id: question } }
            .to_not change(Question, :count)
      end

      it 'redirects to index view' do
        process :destroy, method: :delete, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
