class Recurso < ActiveRecord::Base
	belongs_to :tramite
	belongs_to :tipo_recurso
end
