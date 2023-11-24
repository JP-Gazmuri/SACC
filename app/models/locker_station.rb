class LockerStation < ApplicationRecord
    has_many :lockers

    enum state: {activo:0, inactivo:1}
end
