class Promocion < ActiveRecord::Base
	belongs_to :tramite
	belongs_to :tipo_promocion
	belongs_to :contestacion
end
