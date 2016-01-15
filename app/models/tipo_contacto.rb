class TipoContacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_tipo_contacto"

  has_many :contactos
  has_many "contactos", :foreign_key =>"fk_tipo"
end
