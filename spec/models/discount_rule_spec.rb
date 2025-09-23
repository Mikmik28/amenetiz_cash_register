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
end
