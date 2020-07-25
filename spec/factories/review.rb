
FactoryBot.define do
  factory :review do
    book_id { Faker::Number.unique.number(13)}
    title { Faker::Lorem.characters(5)}
    text { Faker::Lorem.characters(20)}
    user
  end
end
