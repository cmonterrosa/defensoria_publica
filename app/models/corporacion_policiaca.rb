class CorporacionPoliciaca < ActiveRecord::Base
  has_many :participantes
  validates_uniqueness_of :clave
end
