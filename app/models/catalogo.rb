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
  named_scope :materias, :conditions => {:fk_id_catalogos => 209}
  named_scope :medidas_cautelares, :conditions => {:fk_id_catalogos => 201}
  named_scope :idiomas, :conditions => {:fk_id_catalogos => 54}
  named_scope :escolaridades, :conditions => {:fk_id_catalogos => 23}
  named_scope :tipos_amparos, :conditions => {:fk_id_catalogos => 263}
  named_scope :sentido_resolucion_amparo, :conditions => {:fk_id_catalogos => 264}
  named_scope :estados_civiles, :conditions => {:fk_id_catalogos => 26}
  named_scope :relacion_victima, :conditions => {:fk_id_catalogos => 189}

end
