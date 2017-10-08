require 'rails_helper'

describe 'Questions API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:questions)    { create_list(:question, 2) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question)    { create(:question) }
    let(:path)        { "/api/v1/questions/#{question.id}" }
    let(:attachable)  { question }
    let(:commentable) { question }

    it_behaves_like 'API authenticable'
    it_behaves_like 'API attached'
    it_behaves_like 'API commented'

    context 'authorized' do
      let!(:answer)      { create(:answer, question: question) }

      before { get path, params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at rating).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("answers")
        end

        %w(id body created_at updated_at rating).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
                                         .at_path("answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get path, params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:path) { "/api/v1/questions" }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      context 'with valid attributes' do
        it 'returns 200 status code' do
          post path, params: {
              format: :json, access_token: access_token.token,
              question: attributes_for(:question)
          }
          expect(response).to be_success
        end

        it 'saves the new question to database' do
          expect {
            post path, params: {
              format: :json, access_token: access_token.token,
              question: attributes_for(:question) }
          }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post path, params: {
              format: :json, access_token: access_token.token,
              question: attributes_for(:invalid_question)
          }
          expect(response.status).to eq 422
        end

        it "doesn't save the new question to database" do
          expect {
            post path, params: {
              format: :json, access_token: access_token.token,
              question: attributes_for(:invalid_question) }
          }.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post path, params: { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end
