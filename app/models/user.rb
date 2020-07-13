# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy
  has_many :recommended_books
  has_many :favorites, dependent: :destroy
  has_many :book_shelves
  attachment :image

  validates :nickname, presence: true, length: { maximum: 50, minimum: 2 }
  validates :profile, length: { maximum: 600 }
  validates :email, uniqueness: true

  def active_for_authentication?
    super && (is_valid == true)
  end
end
