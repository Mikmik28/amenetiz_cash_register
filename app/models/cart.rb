class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_by_code!(code)
    product = Product.find_by(code: code)
    return unless product

    cart_item = cart_items.find_or_initialize_by(product: product)
    cart_item.qty = cart_item.new_record? ? 1 : cart_item.qty + 1
    cart_item.save!
    cart_item
  end
end
