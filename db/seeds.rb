# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

s = LockerStation.create(name: "Casillero_G13",access_key: "This_is_the_first_key")


s.lockers.create([
    {alto: 45, ancho: 20, largo: 40, number: 1},
    {alto: 45, ancho: 30, largo: 50, number: 2},
    {alto: 45, ancho: 40, largo: 60, number: 3}
])
s2 = LockerStation.create(name: "Casilleros_Roma",access_key: "keykey")
s2.lockers.create([
                   {alto: 45, ancho: 20, largo: 40, number: 1},
                   {alto: 45, ancho: 30, largo: 50, number: 2},
                   {alto: 45, ancho: 40, largo: 60, number: 3}
                 ])

e = Ecommerce.create(name: "Test", key: "access_key_for_eccommers")


