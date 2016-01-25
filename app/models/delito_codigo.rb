class DelitoCodigo < ActiveRecord::Base
	stablish_connection :catalogos
	set_table_name :ca_delitocodigo
	set_primary_key :Id
	belongs_to :delito_norma
	
end
