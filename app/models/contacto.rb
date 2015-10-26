class Contacto < ActiveRecord::Base
  establish_connection "persona"
  set_table_name "pr_contacto"
  belongs_to :persona, :through => :fk_persona
end
