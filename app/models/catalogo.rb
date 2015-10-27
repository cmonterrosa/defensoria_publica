#####################################
# Modelo que consulta los catalogos
#
#####################################

class Catalogo < ActiveRecord::Base
  establish_connection :catalogos
  set_table_name :sis_cat_elementos
  set_primary_key :id_elementos
  
  named_scope :distritos_judiciales, :conditions => {:fk_id_catalogos => 160}
  named_scope :nacionalidades, :conditions => {:fk_id_catalogos => 67}
  named_scope :materias, :conditions => {:fk_id_catalogos => 293}
end
