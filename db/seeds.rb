# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create products with their discount rules
products_data = {
  "GR1" => {
    name: "Green Tea",
    amount_cents: 311,
    discount_rule: {
      rule_type: "bogo",
      threshold_quantity: 1,
      discount_amount_cents: nil
    }
  },
  "SR1" => {
    name: "Strawberries",
    amount_cents: 500,
    discount_rule: {
      rule_type: "bulk_discount",
      threshold_quantity: 3,
      discount_amount_cents: 450  # Reduced price per unit when buying 3+
    }
  },
  "CF1" => {
    name: "Coffee",
    amount_cents: 1123,
    discount_rule: {
      rule_type: "threshold_multiplier",
      threshold_quantity: 3,
      discount_amount_cents: nil  # Uses 2/3 calculation
    }
  }
}

products_data.each do |code, attributes|
  product = Product.find_or_create_by!(code: code) do |p|
    p.name = attributes[:name]
    p.amount_cents = attributes[:amount_cents]
  end

  # Create or update discount rule if it doesn't exist
  if attributes[:discount_rule] && !product.discount_rule
    product.create_discount_rule!(attributes[:discount_rule])
  elsif attributes[:discount_rule] && product.discount_rule
    product.discount_rule.update!(attributes[:discount_rule])
  end
end

puts "Created #{Product.count} products with discount rules"
puts "Created #{DiscountRule.count} discount rules"
