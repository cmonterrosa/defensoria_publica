###################################
# = Modelo que contiene adscripciones
###################################

class Adscripcion < ActiveRecord::Base
  has_many :audiencias
  has_many :users, :conditions => "activo = true"
end
