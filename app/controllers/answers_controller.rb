class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy, :accept]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy, :accept]

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
