# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.where(email:'e.j.norling@sheffield.ac.uk').first_or_create(password:'password', password_confirmation:'password').update(admin: true)
User.where(email:'t.yasseen@sheffield.ac.uk').first_or_create(password:'password', password_confirmation:'password').update(admin: true)
User.where(email:'user@sheffield.ac.uk').first_or_create(password:'password', password_confirmation:'password')