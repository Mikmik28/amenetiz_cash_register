class Checkout
  def initialize(cart)
    @cart = cart
    @catalog = catalog
  end

  def scan(code)
    cart.add_by_code!(code)
    self
  end

  def total
    cart.cart_items.includes(:product).sum do |item|
      product = item.product
      quantity = item.qty
      discount_rule = product.discount_rule

      if discount_rule
        Money.new(discount_rule.apply_discount(quantity, product.amount_cents))
      else
        quantity * product.amount
      end
    end
  end

  private

  attr_reader :cart, :catalog
end
