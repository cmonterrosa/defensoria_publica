##############################################
# Modelo de catálogo de estatus del trámite
#
##############################################

class Estatu < ActiveRecord::Base
  has_many :tramites
  validates_uniqueness_of :clave
end
