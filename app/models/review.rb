# frozen_string_literal: true

class Review < ApplicationRecord
	belongs_to :user
	has_many :favorites
end
