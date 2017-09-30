class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.all
    respond_with @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id)))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
