######################################
# Modelo que se conecta a tabla de municipios
# dentro de base de datos de catalogos
######################################

class Municipio < ActiveRecord::Base
  establish_connection :catalogos
  set_table_name :ca_municipio
  set_primary_key :id_municipio
  belongs_to :entidad_federativa, :foreign_key => "id_entfed"

  named_scope :chiapas, :conditions => {:id_entfed => 7}
end
