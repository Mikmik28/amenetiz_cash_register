class Product < ApplicationRecord
  VALID_DISCOUNT_RULES = [nil, "bogo", "bulk_discount", "threshold_multiplier"].freeze

  # Money integration
  monetize :amount_cents

  # Validations
  validates :code, presence: true, uniqueness: true
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :discount_rule, inclusion: { in: VALID_DISCOUNT_RULES }, allow_nil: true
end
