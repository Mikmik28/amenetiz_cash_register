class AddDiscountRuleToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :discount_rule, :string, null: true
    add_index :products, :discount_rule
  end
end
