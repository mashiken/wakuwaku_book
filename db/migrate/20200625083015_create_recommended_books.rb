# frozen_string_literal: true

class CreateRecommendedBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :recommended_books do |t|
      t.integer :user_id, null: false
      t.integer :recommended_user_id, null: false
      t.string   :book_id, null: false
      t.string   :title, null: false
      t.text   :text, null: false

      t.timestamps
    end
  end
end
