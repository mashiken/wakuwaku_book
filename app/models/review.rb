# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :title, presence: true, length: { maximum: 50, minimum: 2 }
  validates :text, presence: true, length: { maximum: 600, minimum: 10 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
