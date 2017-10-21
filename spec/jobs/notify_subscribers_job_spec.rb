require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:question)     { create(:question) }
  let!(:answer)       { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }

  it 'notifies subscribers' do
    question.subscriptions.each do |subscription|
      expect(AnswersMailer).to receive(:notify_subscriber).with(subscription).and_call_original
    end

    NotifySubscribersJob.perform_now(answer)
  end
end
