User.create!(name: 'Example User',
             email: 'example@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true)

99.times do |n|
  User.create!(name: Faker::Name.name,
               email: "example-#{ n + 1 }@railstutorial.org",
               password: 'password',
               password_confirmation: 'password')
end

users = User.limit(6)
50.times do
  users.each do |user|
    user.microposts.create!(content: Faker::Lorem.sentence)
  end
end

users = User.all
user  = users.first
followed_users = users[2..50]
followers      = users[3..40]
followed_users.each { |followed| user.follow!(followed) }
followers.each { |follower| follower.follow!(user) }
