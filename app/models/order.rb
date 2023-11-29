class Order < ApplicationRecord
    belongs_to :ecommerce
    belongs_to :locker

    enum state: {reservado: 0, confirmado: 1, reportado_a_casillero:2 , en_casillero: 3, finalizado: 4, cancelado: 5}
end
