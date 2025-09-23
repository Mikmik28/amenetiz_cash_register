require 'rails_helper'

RSpec.describe DiscountRule, type: :model do
  let(:product) { create(:product, code: 'TEST', name: 'Test Product', amount_cents: 1000) }

  describe 'validations' do
    it 'accepts valid rule types' do
      DiscountRule::RULE_TYPES.each do |rule_type|
        rule = build(:discount_rule, product: product, rule_type: rule_type)
        # Set required fields based on rule type
        rule.discount_amount_cents = 500 if rule_type == 'bulk_discount'
        expect(rule).to be_valid
      end
    end
  end
  
  describe '#apply_discount' do
    context 'with BOGO rule' do
      let(:bogo_rule) { create(:discount_rule, :bogo, product: product) }

      it 'applies BOGO discount when quantity meets threshold' do
        result = bogo_rule.apply_discount(2, 1000)
        expect(result).to eq(1000)
      end

      it 'applies BOGO discount when quantity exceeds threshold' do
        result = bogo_rule.apply_discount(3, 1000)
        expect(result).to eq(2000)
      end

      it 'applies BOGO discount when quantity is much higher' do
        result = bogo_rule.apply_discount(5, 1000)
        expect(result).to eq(3000)
      end

      it 'does not apply discount when quantity is below threshold' do
        bogo_rule.threshold_quantity = 2
        result = bogo_rule.apply_discount(1, 1000)
        expect(result).to eq(1000)
      end
    end

    context 'with bulk discount rule' do
      let(:bulk_rule) { create(:discount_rule, :bulk_discount, product: product, threshold_quantity: 3, discount_amount_cents: 800) }

      it 'applies bulk discount when quantity meets threshold' do
        result = bulk_rule.apply_discount(3, 1000)
        expect(result).to eq(2400)
      end

      it 'applies bulk discount when quantity exceeds threshold' do
        result = bulk_rule.apply_discount(5, 1000)
        expect(result).to eq(4000)
      end

      it 'does not apply discount when quantity is below threshold' do
        result = bulk_rule.apply_discount(2, 1000)
        expect(result).to eq(2000)
      end
    end

    context 'with threshold multiplier rule' do
      let(:threshold_rule) { create(:discount_rule, :threshold_multiplier, product: product, threshold_quantity: 3) }

      it 'applies 2/3 discount when quantity meets threshold' do
        result = threshold_rule.apply_discount(3, 1000)
        expect(result).to eq(2000)
      end

      it 'applies 2/3 discount when quantity exceeds threshold' do
        result = threshold_rule.apply_discount(4, 1000)
        expect(result).to eq(2666)
      end

      it 'does not apply discount when quantity is below threshold' do
        result = threshold_rule.apply_discount(2, 1000)
        expect(result).to eq(2000)
      end
    end
  end
end
