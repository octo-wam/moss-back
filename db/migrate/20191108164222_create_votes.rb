class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :answer, type: :uuid, foreign_key: true
      t.string :user_id
      t.string :user_name

      t.timestamps
    end
  end
end
