class Order < ApplicationRecord
    belongs_to :ecommerce
    belongs_to :locker

    enum state: {reservado: 0, confirmado: 1, en_casillero: 2, finalizado: 3, cancelado: 4}
end
