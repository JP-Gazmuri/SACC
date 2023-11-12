class CreateEcommerce < ActiveRecord::Migration[7.0]
  def change
    create_table :ecommerces do |t|
      t.string :name, null: false
      t.string :key
      t.integer :state, null: false, default: 0
      t.timestamps
    end
  end
end
