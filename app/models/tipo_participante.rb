class TipoParticipante < ActiveRecord::Base
  has_many :participantes
end
