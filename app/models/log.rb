class Log < ApplicationRecord
  before_save :set_fecha

  private

  def set_fecha
    self.fecha = Time.current
  end
end
