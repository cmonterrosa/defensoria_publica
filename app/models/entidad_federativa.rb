######################################
# Modelo que se conecta a tabla de entidades federativas
# dentro de base de datos de catalogos
######################################

class EntidadFederativa < ActiveRecord::Base
  establish_connection :catalogos
  set_table_name :ca_entidadfederativa
  set_primary_key :id_entfed
  belongs_to :pais, :foreign_key => "id_pais"
  has_many :municipios, :foreign_key => "id_entfed"

  named_scope :mexico, :conditions => {:id_pais => 146}
end
