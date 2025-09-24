class Api::V1::CartController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add
    code = params[:code]
    product = Product.find_by(code: code)

    unless product
      render json: { error: "Product not found" }, status: :not_found
      return
    end

    session[:cart] ||= {}
    session[:cart][code] = (session[:cart][code] || 0) + 1

    render json: {
      message: "Added #{product.name} to cart",
      cart: session[:cart],
      total_items: session[:cart].values.sum
    }
  end

  def remove
    code = params[:code]
    product = Product.find_by(code: code)

    unless product
      render json: { error: "Product not found" }, status: :not_found
      return
    end

    session[:cart] ||= {}

    if session[:cart][code] && session[:cart][code] > 0
      session[:cart][code] -= 1
      if session[:cart][code] == 0
        session[:cart].delete(code)
      end
      render json: {
        message: "Removed #{product.name} from cart",
        cart: session[:cart],
        total_items: session[:cart].values.sum
      }
    else
      render json: { error: "Item not in cart" }, status: :not_found
    end
  end

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
