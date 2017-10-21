require "rails_helper"

RSpec.describe AnswersMailer, type: :mailer do
  describe "notify_subscriber" do
    let!(:subscription) { create(:subscription) }
    let(:mail)          { AnswersMailer.notify_subscriber(subscription) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify subscriber")
      expect(mail.to).to eq([subscription.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(subscription.question.title)
    end
  end
end
