FactoryBot.define do
  factory :product do
    trait :green_tea do
      code { "GR1" }
      name { "Green Tea" }
      amount_cents { 311 }
    end

    trait :strawberries do
      code { "SR1" }
      name { "Strawberries" }
      amount_cents { 500 }
    end

    trait :coffee do
      code { "CF1" }
      name { "Coffee" }
      amount_cents { 1123 }
    end
  end
end