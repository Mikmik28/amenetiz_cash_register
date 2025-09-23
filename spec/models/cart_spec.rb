require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:gr1) { create(:product, :green_tea) }
  let(:cart) { Cart.create }

  describe "#add_by_code!" do
    it { expect { cart.add_by_code!("GR1") }.to change { cart.cart_items.count }.from(0).to(1) }

    it "creates a cart item for a known product code" do
      cart.add_by_code!("GR1")
      item = cart.cart_items.find_by(product: gr1)
      expect(item.qty).to eq(1)
    end

    context "when the product is already in the cart" do
      before { cart.add_by_code!("GR1") }

      it "increments the quantity of the existing cart item" do
        expect { cart.add_by_code!("GR1") }.not_to change { cart.cart_items.count }
        item = cart.cart_items.find_by(product: gr1)
        expect(item.qty).to eq(2)
      end
    end
  end
end
