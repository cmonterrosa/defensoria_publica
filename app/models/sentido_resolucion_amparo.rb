# = Modelo que categoriza la resolcion de amparos resueltos
#
class SentidoResolucionAmparo < ActiveRecord::Base
    has_many :amparos
end
