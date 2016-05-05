class MecanismoAlternativo < ActiveRecord::Base
	belongs_to :tramite
  belongs_to :tipo_mecanismo
end
