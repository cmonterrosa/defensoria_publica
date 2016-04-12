class Sentencia < ActiveRecord::Base
	belongs_to :tramite
	belongs_to :tipo_sentencia
end
