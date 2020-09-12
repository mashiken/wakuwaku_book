# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

## Userのダミーデーター
#50.times do |n|
#  email = "wakuwaku2-#{n+1}@sakura"
#  password = "password"
#  User.create!(nickname: Faker::Name.name,
#               email: email,
#               password:              password,
#               password_confirmation: password)
#end
#
## レビューのダミーデーター
#50.times do |n|
#	Review.create!(user_id: 1,
#		           book_id: "9784065177792",
#		           title: Faker::Lorem.characters(5),
#		           text: Faker::Lorem.characters(20), )
#end

# オススメ数ダミーデーター
50.times do |n|
	RecommendedBook.create!(user_id: 1,
		                    recommended_user_id: 2,
		                    book_id: "9784065177792",
		                    title: Faker::Lorem.characters(5),
		                    text:Faker::Lorem.characters(20))
end

# オススメされ数ダミーデーター
50.times do |n|
	RecommendedBook.create!(user_id: 2,
		                    recommended_user_id: 1,
		                    book_id: "9784906993871",
		                    title: Faker::Lorem.characters(5),
		                    text:Faker::Lorem.characters(20))
end
#AdminUser.create!(email: 'admin@example.com', password: '33333333', password_confirmation: '33333333')
