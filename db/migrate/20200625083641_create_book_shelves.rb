# frozen_string_literal: true

class CreateBookShelves < ActiveRecord::Migration[5.2]
  def change
    create_table :book_shelves do |t|
      t.integer :user_id, null: false
      t.string :book_id, null: false

      t.timestamps
    end
  end
end
