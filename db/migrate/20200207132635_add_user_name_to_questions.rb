class AddUserNameToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :user_name, :string
  end
end
