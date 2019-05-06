admin = User.create!(
  email: "test@test.com",
  password: "111111",
  name: "testuser",
  admin: true,
)
no_admin = User.create!(
  email: "test2@test.com",
  password: "111111",
  name: "testuser2",
  admin: false,
)
5.times { |count| Label.create!(name: "ラベル#{count + 1}") }
status = ["未着手", "着手中", "完了"]
5.times do |i| 
  Task.create(
    title: "タイトル#{i}",
    content: "コンテント#{i}",
    deadline: Date.today + i,
    status: status[rand(status.length)],
    priority: rand(0..2),
    user_id: admin,
  )
end
5.times do |i| 
  Task.create(
    title: "タイトル#{i}",
    content: "コンテント#{i}",
    deadline: Date.today + i,
    status: status[rand(status.length)],
    priority: rand(0..2),
    user_id: no_admin,
  )
end

Paste.create(
  task_id: (1..10),
  label_id: rand(5)
)