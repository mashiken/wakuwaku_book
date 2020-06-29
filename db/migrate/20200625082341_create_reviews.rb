# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer  :user_id, null: false
      t.string   :book_id, null: false
      t.string   :title, null: false
      t.string   :text, null: false

      t.timestamps
    end
  end
end
