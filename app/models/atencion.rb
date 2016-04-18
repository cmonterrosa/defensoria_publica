################################
#  Modelo que maneja y guarda registro de atención
#  por parte de los usuarios hacia un trámite
################################

class Atencion < ActiveRecord::Base
  belongs_to :user
  belongs_to :tramite
end
