class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer was deleted.'
    else
      redirect_to @answer.question, notice: 'Holy guacamole! Permission denied!'
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
