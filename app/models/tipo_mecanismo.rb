class TipoMecanismo < ActiveRecord::Base
	has_many :mecanismo_alternativos
end
