require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:identities).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User tries to manage resource' do
    let(:user) { create(:user) }

    it 'returns true if user is author of resource' do
      question = create(:question, user: user)

      expect(user).to be_author_of(question)
    end

    it 'returns false if user is not author of resource' do
      question = create(:question, user: create(:user))

      expect(user).to_not be_author_of(question)
    end
  end

  describe '.find_for_authentication' do
    let!(:user) { create(:user) }

    context 'user already signed in with this oauth provider earlier' do
      let(:identity) { create(:identity, user: user) }
      let(:auth_hash) { OmniAuth::AuthHash.new(provider: identity.provider, uid: identity.uid) }

      it 'returns user' do
        expect(User.find_for_oauth(auth_hash)).to eq user
      end
    end

    context 'user sign in with this oauth provider for the first time' do
      context 'user with given email exists' do
        let(:identity) { build(:identity, user: user) }
        let(:auth_hash) { OmniAuth::AuthHash.new(provider: identity.provider,
                                                 uid: identity.uid,
                                                 info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth_hash) }.to_not change(User, :count)
        end

        it 'creates new identity for user' do
          expect { User.find_for_oauth(auth_hash) }.to change(user.identities, :count).by(1)
        end

        it 'creates identity with given provider and uid' do
          user_identity = User.find_for_oauth(auth_hash).identities.first
          expect(user_identity.provider).to eq auth_hash.provider
          expect(user_identity.uid).to eq auth_hash.uid
        end

        it 'returns found user' do
          expect(User.find_for_oauth(auth_hash)).to eq user
        end
      end

      context 'user with given email does not exist' do
        let(:identity) { attributes_for(:identity) }
        let(:auth_hash) { OmniAuth::AuthHash.new(provider: identity[:provider],
                                                 uid: identity[:uid],
                                                info: { email: 'test@test.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth_hash) }.to change(User, :count).by(1)
        end

        it 'returns created user' do
          expect(User.find_for_oauth(auth_hash)).to be_a(User)
        end

        it 'sets given email for user' do
          user = User.find_for_oauth(auth_hash)
          expect(user.email).to eq auth_hash.info[:email]
        end

        it 'creates identity for created user' do
          user = User.find_for_oauth(auth_hash)
          expect(user.identities).to_not be_empty
        end

        it 'creates identity with given provider and uid' do
          user_identity = User.find_for_oauth(auth_hash).identities.first
          expect(user_identity.provider).to eq auth_hash.provider
          expect(user_identity.uid).to eq auth_hash.uid
        end
      end
    end
  end
end
