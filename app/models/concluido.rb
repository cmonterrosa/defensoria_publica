#######################################
# = Modelo que almacena tramites concluidos y lo vincula con el
# usuario que concluyo, fechahora y el motivo
#######################################
class Concluido < ActiveRecord::Base
  has_many :tramites
  belongs_to :user
  belongs_to :motivo_conclusion
end
