class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :ecommerce, foreign_key: { to_table: :ecommerces }, null: false
      t.integer :state, default: 0
      t.string :deposit_password
      t.string :retrieve_password
      t.string :operator_contact
      t.string :client_contact
      t.string :operator_name
      t.string :client_name
      t.datetime :delivery_time
      t.datetime :retrieve_time
      t.integer :height
      t.integer :width
      t.integer :length
      t.timestamps
    end
  end
end
