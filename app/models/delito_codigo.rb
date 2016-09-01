class DelitoCodigo < ActiveRecord::Base
  establish_connection :catalogos
	set_table_name :ca_delitocodigo
	set_primary_key :Id
	belongs_to :delito_norma
  has_many :tramites


  def descripcion
    self.Codigo
  end
	
end
