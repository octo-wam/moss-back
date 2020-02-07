class AddUserIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :user_id, :string
  end
end
