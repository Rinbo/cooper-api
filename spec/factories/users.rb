FactoryBot.define do
  factory :user do
    email { "robin.b@outlook.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
