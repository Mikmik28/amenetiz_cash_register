RSpec.describe Checkout, type: :service do
  let!(:gr1) { create(:product, :green_tea) }
  let(:cart) { Cart.create }
  let(:checkout) { Checkout.new(cart) }

  describe "#scan" do
    it "adds a product to the cart by its code" do
      expect { checkout.scan("GR1") }.to change { cart.cart_items.count }.from(0).to(1)
      item = cart.cart_items.find_by(product: gr1)
      expect(item.qty).to eq(1)
    end
  end

  describe "#total" do
    before do
      checkout.scan("GR1")
      checkout.scan("GR1")
    end

    it "calculates the total price of the cart" do
      expect(checkout.total).to eq(gr1.amount * 2)
    end
  end
end