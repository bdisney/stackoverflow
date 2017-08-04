class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :votable, polymorphic: true, index: true
      t.integer :value

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true, name: 'index_unique_user_vote'
  end
end
