FactoryBot.define do
  factory :user do
    name { "testman" }
    email { "test@test.com" }
    password { "111111" }
    password_confirmation { "111111" }
  end

end