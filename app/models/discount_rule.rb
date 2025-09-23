class DiscountRule < ApplicationRecord
  belongs_to :product

  # Constants for rule types
  BOGO = "bogo".freeze
  BULK_DISCOUNT = "bulk_discount".freeze
  THRESHOLD_MULTIPLIER = "threshold_multiplier".freeze

  RULE_TYPES = [ BOGO, BULK_DISCOUNT, THRESHOLD_MULTIPLIER ].freeze

  # Money integration for discount amount
  monetize :discount_amount_cents, allow_nil: true

  # Validations
  validates :rule_type, presence: true, inclusion: { in: RULE_TYPES }
  validates :threshold_quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :discount_amount_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # Custom validations
  validate :validate_bulk_discount_amount

  def apply_discount(quantity, original_price_cents)
    case rule_type
    when BOGO
      apply_bogo_discount(quantity, original_price_cents)
    when BULK_DISCOUNT
      apply_bulk_discount(quantity, original_price_cents)
    when THRESHOLD_MULTIPLIER
      apply_threshold_multiplier_discount(quantity, original_price_cents)
    else
      quantity * original_price_cents
    end
  end

  private

    def validate_bulk_discount_amount
      if rule_type == BULK_DISCOUNT && discount_amount_cents.blank?
        errors.add(:discount_amount_cents, "must be present for bulk discount")
      end
    end

    def apply_bogo_discount(quantity, original_price_cents)
      return full_price(quantity, original_price_cents) unless discount_applies?(quantity)

      paid_quantity = (quantity + 1) / 2
      paid_quantity * original_price_cents
    end

    def apply_bulk_discount(quantity, original_price_cents)
      return full_price(quantity, original_price_cents) unless discount_applies?(quantity)

      quantity * discount_amount_cents
    end

    def apply_threshold_multiplier_discount(quantity, original_price_cents)
      return full_price(quantity, original_price_cents) unless discount_applies?(quantity)

      (quantity * original_price_cents * 2) / 3
    end

    def discount_applies?(quantity)
      quantity >= threshold_quantity
    end

    def full_price(quantity, original_price_cents)
      quantity * original_price_cents
    end
end
