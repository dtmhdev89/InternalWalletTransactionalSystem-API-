FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "johndoe-#{n}@localhost.mail" }
    password { "Aa@123456" }
    type { "User" }
  end
end
