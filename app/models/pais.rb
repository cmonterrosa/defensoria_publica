######################################
# Modelo que se conecta a tabla de paises
# dentro de base de datos de catalogos
######################################

class Pais < ActiveRecord::Base
  establish_connection :catalogos
  set_table_name :ca_pais
  set_primary_key :id_pais
  has_many :entidad_federativas, :foreign_key => "id_pais"
end
