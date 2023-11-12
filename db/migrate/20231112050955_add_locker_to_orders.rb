class AddLockerToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :locker, null: false, foreign_key: true
  end
end
