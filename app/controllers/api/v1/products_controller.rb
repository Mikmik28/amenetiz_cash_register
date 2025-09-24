class Api::V1::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    products = Product.includes(:discount_rule).all
    render json: products.map { |product|
      {
        id: product.id,
        code: product.code,
        name: product.name,
        price: product.amount.format,
        price_cents: product.amount_cents,
        discount_rule: product.discount_rule&.display_name
      }
    }
  end
end
