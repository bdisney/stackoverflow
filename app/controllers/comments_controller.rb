class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]
  before_action :set_commentable, only: [:new, :create]
  after_action  :publish_comment, only: :create

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, include: { user: { only: :email } }, status: :ok
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    render status: :forbidden unless current_user.author_of?(@comment)
    @comment.destroy
  end

  private

  def publish_comment
    return if @comment.errors.any?

    data = {
      commentable_id: @comment.commentable_id,
      commentable_type: @comment.commentable_type.underscore,
      comment: @comment,
      comment_user_email: current_user.email
    }
    ActionCable.server.broadcast("comments", data)
  end

  def set_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end

    head :unprocessable_entity unless @commentable
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
