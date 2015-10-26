class TipoContacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_tipo_contacto"
end
