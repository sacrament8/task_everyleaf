User.create!(
  email: "test@test.com",
  password: "111111",
  name: "testuser",
  admin: true,
)

5.times { |count| Label.create!(name: "ラベル#{count + 1}") }