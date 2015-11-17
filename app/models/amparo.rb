class Amparo < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :tipo_amparo
end
