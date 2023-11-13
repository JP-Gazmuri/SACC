# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

s = LockerStation.create(name: "First",access_key: "This_is_the_first_key")

s.lockers.create([
    {height: 45, width: 20, length: 40, number: 1},
    {height: 45, width: 30, length: 50, number: 2},
    {height: 45, width: 40, length: 60, number: 3}
])

e = Ecommerce.create(name: "Test", key: "access_key_for_eccommers")

ord = Order.create([
    {ecommerce: e, deposit_password: "873612", retrieve_password:"768734", locker: Locker.where(number: 1).first},
    {ecommerce: e, deposit_password: "103668", retrieve_password:"083551", locker: Locker.where(number: 2).first},
    {ecommerce: e, deposit_password: "999999", retrieve_password:"682661", locker: Locker.where(number: 3).first}
])