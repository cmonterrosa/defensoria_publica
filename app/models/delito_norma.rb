class DelitoNorma < ActiveRecord::Base
	stablish_connection :catalogos
	set_table_name :ca_delitonorma 
	set_primary_key :id
	has_many :delito_codigos

end
