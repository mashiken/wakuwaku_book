# frozen_string_literal: true

class RecommendedBook < ApplicationRecord
	belongs_to :user
	validates :title,  presence: true, length: {maximum: 50, minimum: 2}
    validates :text,  presence: true, length: {maximum: 600, minimum: 10}
end
