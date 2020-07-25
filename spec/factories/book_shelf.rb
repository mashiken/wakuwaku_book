
FactoryBot.define do
  factory :book_shelf do
    user_id {}
    book_id {Faker::Number.unique.number(13)}
    title {Faker::Lorem.characters(5)}
    text {Faker::Lorem.characters(20)}
  end
end
