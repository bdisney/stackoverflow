class CommentsChannel < ApplicationCable::Channel
  def follow_comments
    stream_from "comments"
  end

  def unfollow
    stop_all_streams
  end
end
