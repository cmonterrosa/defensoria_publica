class TipoContacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "cat_tipo_contacto"
  set_primary_key "id_tipo_contacto"
  #has_many :contactos
  has_many "contactos", :foreign_key =>"fk_tipo"
end
