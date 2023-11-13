class Locker < ApplicationRecord
    belongs_to :locker_station
    has_many :orders
end