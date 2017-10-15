class AnswersMailer < ApplicationMailer

  def notify_subscriber(subscription)
    @subscription = subscription

    mail to: subscription.user.email
  end
end
