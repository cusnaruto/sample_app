User.create!(
  name: "Example User",
  email: "hoangvip3333@gmail.com",
  password: "password",
  password_confirmation: "password",
  gender: 0,
  dob: "2000-01-01",
  admin: true
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
    dob: dob
  )
end
