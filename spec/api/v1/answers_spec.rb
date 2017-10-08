require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before {
        get "/api/v1/questions/#{question.id}/answers",
            params: { format: :json, access_token: access_token.token }
      }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer)}

    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }


      before {
        get "/api/v1/answers/#{answer.id}",
            params: { format: :json, access_token: access_token.token }
      }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at rating).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                         .at_path("comments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'returns 200 status code' do
          post "/api/v1/questions/#{question.id}/answers",
               params: {
                 format: :json,
                 access_token: access_token.token,
                 answer: attributes_for(:answer)
               }
          expect(response).to be_success
        end

        it 'saves the new answer to database' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json, access_token: access_token.token,
              answer: attributes_for(:answer)
            } }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json, access_token: access_token.token,
              answer: attributes_for(:invalid_answer)
          }
          expect(response.status).to eq 422
        end

        it "doesn't save the new question to database" do
          expect {
            post "/api/v1/questions/#{question.id}/answers", params: {
              format: :json, access_token: access_token.token,
              answer: attributes_for(:invalid_answer)
            } }.to_not change(question.answers, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
