
FactoryBot.define do
  factory :recommended_book do
    user_id {}
    recommended_user_id {}
    book_id { Faker::Number.unique.number(13) }
    title { Faker::Lorem.characters(5)}
    text { Faker::Lorem.characters(20)}
  end
end
