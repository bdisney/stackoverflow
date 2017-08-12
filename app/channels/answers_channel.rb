class AnswersChannel < ApplicationCable::Channel
  def follow_answers(data)
    stream_from "question_#{data['id']}"
  end

  def unfollow_answers
    stop_all_streams
  end
end
