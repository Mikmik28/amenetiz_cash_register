class CreateDiscountRules < ActiveRecord::Migration[8.0]
  def change
    create_table :discount_rules do |t|
      t.string :rule_type, null: false
      t.integer :threshold_quantity, default: 1
      t.integer :discount_amount_cents
      t.references :product, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end

    add_index :discount_rules, :rule_type
  end
end
