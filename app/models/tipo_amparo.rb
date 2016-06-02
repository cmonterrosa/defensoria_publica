############################################
# = Tipos de amparos
#
############################################
class TipoAmparo < ActiveRecord::Base
  has_many :amparos
end
