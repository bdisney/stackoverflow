class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.belongs_to :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :identities, [:provider, :uid]
  end
end
