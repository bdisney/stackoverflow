class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:destroy]
  before_action :set_question, only: [:destroy]

  authorize_resource

  respond_to :js

  def create
    respond_with(@subscription = current_user.subscriptions.create(subscription_params))
  end

  def destroy
    respond_with(@subscription.destroy)
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_question
    @question = @subscription.question
  end

  def subscription_params
    params.require(:subscription).permit(:question_id)
  end
end
