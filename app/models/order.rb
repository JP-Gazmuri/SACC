class Order < ApplicationRecord
    belongs_to :ecommerce
    belongs_to :locker
end