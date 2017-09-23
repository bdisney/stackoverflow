class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.includes(:user)
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.new
    gon.push({ current_user_id: current_user.id }) if user_signed_in?
  end

  def new
    @question = Question.new
    @question.attachments.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if @question.destroy
      redirect_to questions_path, notice: 'Question was deleted.'
    else
      redirect_to questions_path, notice: 'Holy guacamole! Permission denied!'
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/single_question', locals: { question: @question }
      )
    )
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
