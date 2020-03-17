# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users, id: :string do |t|
      t.string :name
      t.string :email
      t.string :photo

      t.timestamps
    end

    add_column :questions, :user_id, :string, references: :user
    change_column :votes, :user_id, :string, references: :user
  end

  def down
    drop_table :users
    remove_column :questions, :user_id
    change_column :votes, :user_id, :string
  end
end
