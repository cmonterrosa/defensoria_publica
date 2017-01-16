class Amparo < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_amparo
  has_one :adjunto
end
