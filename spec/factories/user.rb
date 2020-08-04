
FactoryBot.define do
  factory :user do
  	password = Faker::Internet.password(8)
    nickname { Faker::Lorem.characters(5)}
    email { Faker::Internet.free_email }
    password { password }
    password_confirmation { password }
  end
end
