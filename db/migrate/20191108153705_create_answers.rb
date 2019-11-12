# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers, id: :uuid do |t|
      t.string :title
      t.text :description
      t.references :question, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
