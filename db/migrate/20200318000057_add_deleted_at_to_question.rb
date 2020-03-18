# frozen_string_literal: true

class AddDeletedAtToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :deleted_at, :datetime
    add_index :questions, :deleted_at
  end
end
