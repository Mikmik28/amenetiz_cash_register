class Api::V1::CartController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add
    code = params[:code]
    product = find_product(code)
    return unless product

    cart = ensure_cart_exists
    cart[code] = (cart[code] || 0) + 1

    render json: build_cart_response("Added #{product.name} to cart", cart)
  end

  def remove
    code = params[:code]
    product = find_product(code)
    return unless product

    cart = ensure_cart_exists
    return render_item_not_in_cart_error unless item_in_cart?(cart, code)

    remove_item_from_cart(cart, code)
    render json: build_cart_response("Removed #{product.name} from cart", cart)
  end

  def show
    cart_data = current_cart
    return render_empty_cart if cart_data.empty?

    cart_summary = build_cart_summary(cart_data)
    render json: cart_summary
  end

  private

  def find_product(code)
    product = Product.find_by(code: code)
    render json: { error: "Product not found" }, status: :not_found unless product
    product
  end

  def ensure_cart_exists
    session[:cart] ||= {}
  end

  def current_cart
    session[:cart] || {}
  end

  def build_cart_response(message, cart)
    {
      message: message,
      cart: cart,
      total_items: cart.values.sum
    }
  end

  def item_in_cart?(cart, code)
    cart[code] && cart[code] > 0
  end

  def remove_item_from_cart(cart, code)
    cart[code] -= 1
    cart.delete(code) if cart[code] == 0
  end

  def render_item_not_in_cart_error
    render json: { error: "Item not in cart" }, status: :not_found
  end

  def render_empty_cart
    render json: {
      items: [],
      total: "$0.00",
      total_cents: 0,
      item_count: 0
    }
  end

  def build_cart_summary(cart_data)
    temp_cart = Cart.create
    checkout = Checkout.new(temp_cart)
    cart_items = build_cart_items(cart_data, checkout)
    total = checkout.total
    temp_cart.destroy

    {
      items: cart_items,
      total: total.format,
      total_cents: total.cents,
      item_count: cart_data.values.sum
    }
  end

  def build_cart_items(cart_data, checkout)
    cart_items = []
    cart_data.each do |code, quantity|
      product = Product.find_by(code: code)
      next unless product

      quantity.times { checkout.scan(code) }
      cart_items << build_cart_item(product, code, quantity)
    end
    cart_items
  end

  def build_cart_item(product, code, quantity)
    {
      code: code,
      name: product.name,
      quantity: quantity,
      unit_price: product.amount.format,
      discount_rule: product.discount_rule&.display_name
    }
  end
end
