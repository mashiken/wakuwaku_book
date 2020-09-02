
FactoryBot.define do
  factory :book_shelf do
    user_id { 1 }
    book_id {Faker::Number.unique.number(13)}
  end
end
