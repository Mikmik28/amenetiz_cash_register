class Checkout
  def initialize(cart)
    @cart = cart
    @catalog = catalog
  end

  def scan(code)
    cart.add_by_code!(code)
  end

  def total
    cart.cart_items.includes(:product).sum do |item|
      item.qty * item.product.amount
    end
  end

  private

  attr_reader :cart, :catalog
end
