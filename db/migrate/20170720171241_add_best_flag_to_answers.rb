class AddBestFlagToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :accepted, :boolean, default: false
  end
end
