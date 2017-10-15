class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('updated_at > ?', 1.day.ago)

    mail to: user.email
  end
end
