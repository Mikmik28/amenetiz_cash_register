# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

{
  "GR1" => { name: "Green Tea", amount_cents: 311, discount_rule: "bogo" },
  "SR1" => { name: "Strawberries", amount_cents: 500, discount_rule: "bulk_discount" },
  "CF1" => { name: "Coffee", amount_cents: 1123, discount_rule: "threshold_multiplier" }
}.each do |code, attributes|
  Product.find_or_create_by!(code: code) do |product|
    product.name = attributes[:name]
    product.amount_cents = attributes[:amount_cents]
    product.discount_rule = attributes[:discount_rule]
  end
end
