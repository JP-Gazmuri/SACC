class Ecommerce < ApplicationRecord
    has_many :orders

    enum state: {activo:0, inactivo:1}
end
