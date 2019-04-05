FactoryBot.define do
  factory :user do
    name { "testman" }
    email { "test@test.com" }
    password { "111111" }
    password_confirmation { "111111" }
    admin { false }
  end
  factory :admin_user, class: User do
    name { "admin_user" }
    email { "ad@test.com" }
    password { "111111" }
    password_confirmation { "111111" }
    admin { true }
  end

end