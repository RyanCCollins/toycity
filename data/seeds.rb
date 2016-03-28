require 'faker'
require_relative './schema'
# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  10.times do |i|
    brand = Faker::Company.name
    name  = Faker::Commerce.product_name
    price = Faker::Commerce.price
    Product.create(brand: brand, name: name, price: price)
  end
end
