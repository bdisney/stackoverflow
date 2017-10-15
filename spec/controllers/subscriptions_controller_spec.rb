require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let!(:user)     { create(:user) }

    before { sign_in user }

    context 'with valid attributes' do
      it 'creates and saves subscription to a question to DB' do
        expect {
          post :create, params: {
            subscription: { question_id: question },
            format: :js }
        }.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'fails to save subscription to the question to DB' do
        expect {
          post :create, params: {
            subscription: { question_id: nil },
            format: :js }
        }.to_not change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription) }

    context 'owner' do
      it 'deletes subscription belonging to user' do
        sign_in(subscription.user)

        expect {
          delete :destroy, params: {
            id: subscription, format: :js
          }
        }.to change(subscription.user.subscriptions, :count).by(-1)
      end
    end

    it "doesn't delete subscription belonging to somebody else" do
      expect {
        delete :destroy, params: {
          id: subscription, format: :js
        }
      }.not_to change(Subscription, :count)
    end
  end
end
