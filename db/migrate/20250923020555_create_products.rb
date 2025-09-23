class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name
      t.integer :amount_cents, null: false

      t.timestamps
    end
  end
end
