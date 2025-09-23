class Product < ApplicationRecord
  # Associations
  has_one :discount_rule, dependent: :destroy

  # Money integration
  monetize :amount_cents

  # Validations
  validates :code, presence: true, uniqueness: true
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
