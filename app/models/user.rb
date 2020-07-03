# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews
  has_many :recommended_books
  has_many :favorites
  has_many :book_shelfs
  attachment :image_id

  def active_for_authentication?
    super && (self.is_valid == true)
  end
end
