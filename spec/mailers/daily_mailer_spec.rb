require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let(:mail)  { DailyMailer.digest(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Daily digest!")
    end
  end
end
