require 'rails_helper'

RSpec.describe "Api::V1::ProductsController", type: :request do
  describe "GET /api/v1/products" do
    before do
      create(:product, code: 'GR1', name: 'Green tea', amount_cents: 311)
      create(:product, code: 'SR1', name: 'Strawberries', amount_cents: 500)
    end

    it "returns all products" do
      get '/api/v1/products'

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)

      product = json.find { |p| p['code'] == 'GR1' }
      expect(product['name']).to eq('Green tea')
      expect(product['price']).to eq('€3.11')
      expect(product['price_cents']).to eq(311)
    end

    it "includes discount rule information" do
      product = create(:product, code: 'CF1', name: 'Coffee', amount_cents: 1123)
      create(:discount_rule, rule_type: 'bogo', threshold_quantity: 1, product: product)

      get '/api/v1/products'

      json = JSON.parse(response.body)
      product = json.find { |p| p['code'] == 'CF1' }
      expect(product['discount_rule']).to eq('Buy 1, get 1 free')
    end
  end
end
