require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users_list) { create_list(:user, 2) }

      before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'has two users' do
        expect(response.body).to have_json_size(2)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          users_list.each_with_index do |other_user, index|
            expect(response.body).to be_json_eql(other_user.send(attr.to_sym).to_json).at_path("#{index}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "does not contain my #{attr}" do
          expect(response.body).to_not be_json_eql(me.send(attr.to_sym).to_json)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/', params: { format: :json }.merge(options)
    end
  end
end
