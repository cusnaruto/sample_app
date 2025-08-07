User.create!(
  name: "Example User",
  email: "22026555@vnu.edu.vn",
  password: "password",
  password_confirmation: "password",
  gender: 0,
  dob: "2000-01-01",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  gender = ["male", "female", "other"].sample
  dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    gender: gender,
    dob: dob,
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.order(:created_at).take(6)

30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
