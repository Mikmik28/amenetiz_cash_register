FactoryBot.define do
  factory :discount_rule do
    rule_type { "bogo" }
    threshold_quantity { 1 }
    discount_amount_cents { nil }
    association :product

    trait :bogo do
      rule_type { "bogo" }
      threshold_quantity { 1 }
      discount_amount_cents { nil }
    end

    trait :bulk_discount do
      rule_type { "bulk_discount" }
      threshold_quantity { 3 }
      discount_amount_cents { 450 }
    end

    trait :threshold_multiplier do
      rule_type { "threshold_multiplier" }
      threshold_quantity { 3 }
      discount_amount_cents { nil }
    end
  end
end
