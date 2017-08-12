class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy, :accept]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy, :accept]

  after_action :publish_answer, only: [:create]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def accept
    @answer.accept if current_user.author_of?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each { |a| attachments << {id: a.id, file_url: a.file.url, file_name: a.file.identifier} }

    data = {
      answer:             @answer,
      answer_user_id:     current_user.id,
      question_user_id:   @question.user_id,
      answer_rating:      @answer.rating,
      answer_attachments: attachments,
      user_avatar_url:    ActionController::Base.helpers.gravatar_image_url(current_user.email),
      user_email:         current_user.email,
      answer_created_at:  @answer.created_at.strftime('%b %-d \'%y at %H:%M')
    }
    ActionCable.server.broadcast("answers_#{params[:question_id]}", data)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
