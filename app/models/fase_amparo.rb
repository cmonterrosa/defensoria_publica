# = Fase para amparos recurridos
#
class FaseAmparo < ActiveRecord::Base
    has_many :amparos
end
