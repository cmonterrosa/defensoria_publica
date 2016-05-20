#####################################
# Modelo que consulta los catalogos
#
#####################################

class Catalogo < ActiveRecord::Base
  establish_connection :catalogos
  set_table_name :sis_cat_elementos
  set_primary_key :id_elementos
  
  named_scope :distritos_judiciales, :conditions => {:fk_id_catalogos => 160}
  named_scope :nacionalidades, :conditions => {:fk_id_catalogos => 67}, :order => :descripcion
  named_scope :materias, :conditions => {:fk_id_catalogos => 209}, :order => :descripcion
  named_scope :medidas_cautelares, :conditions => {:fk_id_catalogos => 201}
  named_scope :idiomas, :conditions => {:fk_id_catalogos => 54}, :order => :descripcion
  named_scope :escolaridad, :conditions => {:fk_id_catalogos => 23}, :order => :descripcion
  named_scope :tipos_amparos, :conditions => {:fk_id_catalogos => 263}, :order => :descripcion
  named_scope :sentido_resolucion_amparo, :conditions => {:fk_id_catalogos => 264}, :order => :descripcion
  named_scope :estado_civil, :conditions => {:fk_id_catalogos => 26} , :order => :descripcion
  named_scope :parentesco, :conditions => {:fk_id_catalogos => 189}, :order => :descripcion
  named_scope :estatus_audiencia, :conditions => {:fk_id_catalogos => 30}, :order => :descripcion
  named_scope :tipo_audiencia, :conditions => {:fk_id_catalogos => 100}, :order => :descripcion
  named_scope :caracter_audiencia, :conditions => {:fk_id_catalogos => 236}, :order => :descripcion
  named_scope :institucion_solicitante, :conditions => {:fk_id_catalogos => 237}, :order => :descripcion
  named_scope :motivos_cancelar_audiencia, :conditions => {:fk_id_catalogos => 275}, :order => :descripcion
  named_scope :motivos_diferir_audiencia, :conditions => {:fk_id_catalogos => 276}, :order => :descripcion
  named_scope :motivos_reagendar_audiencia, :conditions => {:fk_id_catalogos => 277}, :order => :descripcion
  named_scope :motivos_suspender_audiencia, :conditions => {:fk_id_catalogos => 278}, :order => :descripcion
  named_scope :sexos, :conditions => {:fk_id_catalogos => 239}, :order => :descripcion

end

