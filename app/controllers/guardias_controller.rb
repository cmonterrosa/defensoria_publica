###############################################
# = Administración de las guardias de los defensores públicos activos
#
###############################################

class GuardiasController < ApplicationController
  before_filter :login_required
  
  def index
  end

  def index
    @defensor = Defensor.find(params[:persona])
    @guardias = Guardia.find(:all, :conditions => ["persona_id = ?", @defensor.persona]) if @defensor
    @guardias = Guardia.find(:all)
  end

end
