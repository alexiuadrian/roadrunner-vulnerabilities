# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_role = Role.create(name: "user")

users_manager_role = Role.create(name: "user_manager")

admin_role = Role.create(name: "admin")

admin = User.create(username: "admin", password: "admin", email: "admin@admin.com")
admin.add_role :admin
admin.add_role :user_manager
admin.add_role :user

user1 = User.create(username: "adi", password: "123456", email: "adi.alexiu@gmail.com")
user1.add_role :user
user1.add_role :user_manager

user2 = User.create(username: "user2", password: "123456", email: "user2@roadrunner.com")
user2.add_role :user
