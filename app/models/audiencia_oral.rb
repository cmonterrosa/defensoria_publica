class AudienciaOral < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_audiencia
end
