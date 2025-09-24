class Api::V1::CartController < ApplicationController
  def show
    cart_data = session[:cart] || {}

    if cart_data.empty?
      render json: {
        items: [],
        total: "$0.00",
        total_cents: 0,
        item_count: 0
      }
      return
    end

    # Create a temporary cart and checkout to calculate total
    temp_cart = Cart.create
    checkout = Checkout.new(temp_cart)

    cart_items = []
    cart_data.each do |code, quantity|
      product = Product.find_by(code: code)
      next unless product

      quantity.times { checkout.scan(code) }

      cart_items << {
        code: code,
        name: product.name,
        quantity: quantity,
        unit_price: product.amount.format,
        discount_rule: product.discount_rule&.display_name
      }
    end

    total = checkout.total

    # Clean up temporary cart
    temp_cart.destroy

    render json: {
      items: cart_items,
      total: total.format,
      total_cents: total.cents,
      item_count: cart_data.values.sum
    }
  end
end
