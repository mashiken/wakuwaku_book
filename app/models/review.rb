# frozen_string_literal: true

class Review < ApplicationRecord

	belongs_to :user
	has_many :favorites
	validates :title,  presence: true, length: {maximum: 50, minimum: 2}
    validates :text,  presence: true, length: {maximum: 600, minimum: 10}
end
