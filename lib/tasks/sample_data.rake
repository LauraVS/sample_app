namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end


# Tarea para crear 100 usuarios
def make_users
  admin = User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end


# Adding 50 microposts only to the first 6 users
def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end


def make_relationships
  users = User.all
  firstUser  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]

  # firstUser va a seguir a cada uno de los usuarios en "followed_users" (users 3 through 51)
  followed_users.each { |followed| firstUser.follow!(followed) }

  # Todos los usuarios en "followers" van a seguir a firstUser (users 4 through 41)
  followers.each      { |follower| follower.follow!(firstUser) }
end