require 'rails_helper'

RSpec.describe Checkout, type: :service do
  let!(:gr1) { create(:product, :green_tea, amount_cents: 311) }
  let(:cart) { Cart.create }
  let(:checkout) { Checkout.new(cart) }

  describe "#scan" do
    it { expect { checkout.scan("GR1") }.to change { cart.cart_items.count }.from(0).to(1) }

    it "adds a product to the cart by its code" do
      checkout.scan("GR1")
      item = cart.cart_items.find_by(product: gr1)
      expect(item.qty).to eq(1)
    end
  end

  describe "#total" do
    it "calculates the total price of the cart" do
      checkout.scan("GR1")
      checkout.scan("GR1")
      expect(checkout.total).to eq(Money.from_amount(6.22))
    end

    context "when the product has no discount_rule" do
      let!(:sr1) { create(:product, :strawberries, amount_cents: 500,discount_rule: nil) }

      it "calculates the total without any discount" do
        checkout.scan("SR1")
        checkout.scan("SR1")
        expect(checkout.total).to eq(Money.from_amount(10.00))
      end
    end

    context "when the product has a discount_rule" do
      let!(:sr1) { create(:product, :strawberries, amount_cents: 500, discount_rule: "bulk_discount") }

      it "applies the discount rule to the total" do
        checkout.scan("SR1")
        checkout.scan("SR1")
        checkout.scan("SR1")
        expect(checkout.total).to eq(Money.from_amount(13.50))
      end
    end

    context "when different products with different discount_rules are in the cart" do
      let!(:sr1) { create(:product, :strawberries, amount_cents: 500, discount_rule: "bulk_discount") }
      let!(:cf1) { create(:product, :coffee, amount_cents: 1123, discount_rule: "threshold_multiplier") }

      it "applies the respective discount rules to each product" do
        checkout.scan("GR1")
        checkout.scan("GR1")
        checkout.scan("SR1")
        checkout.scan("SR1")
        checkout.scan("SR1")
        checkout.scan("CF1")
        expect(checkout.total).to eq(Money.from_amount(25.95))
      end
    end
  end
end