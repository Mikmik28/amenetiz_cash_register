FactoryBot.define do
  factory :product do
    trait :green_tea do
      code { "GR1" }
      name { "Green Tea" }
      amount_cents { 311 }

      after(:create) do |product|
        create(:discount_rule, :bogo, product: product)
      end
    end

    trait :strawberries do
      code { "SR1" }
      name { "Strawberries" }
      amount_cents { 500 }

      after(:create) do |product|
        create(:discount_rule, :bulk_discount, product: product)
      end
    end

    trait :coffee do
      code { "CF1" }
      name { "Coffee" }
      amount_cents { 1123 }

      after(:create) do |product|
        create(:discount_rule, :threshold_multiplier, product: product)
      end
    end

    # Traits for creating products with specific discount rules
    trait :with_bogo do
      after(:create) do |product|
        create(:discount_rule, :bogo, product: product)
      end
    end

    trait :with_bulk_discount do
      after(:create) do |product|
        create(:discount_rule, :bulk_discount, product: product)
      end
    end

    trait :with_threshold_multiplier do
      after(:create) do |product|
        create(:discount_rule, :threshold_multiplier, product: product)
      end
    end
  end
end
