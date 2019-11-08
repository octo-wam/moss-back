class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
    create_table :questions, id: :uuid do |t|
      t.string :title
      t.text :description
      t.datetime :ending_date

      t.timestamps
    end
  end
end
