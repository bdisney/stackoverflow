class AddUserIdToQuestionsAndAnswers < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :questions, :user, index: true
    add_belongs_to :answers, :user, index: true
  end
end
