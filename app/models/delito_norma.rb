class DelitoNorma < ActiveRecord::Base
	establish_connection :catalogos
	set_table_name :ca_delitonorma 
	set_primary_key :Id
	has_many :delito_codigos

  def descripcion
    self.Norma
  end

end
