# Organización de etapas del trámite
class EtapasController < ApplicationController
  require_role [:defensor, :jefedefensor]

  
  def index
    select_object
  end

  def investigacion_inicial
     @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
     render :partial => "investigacion_inicial", :layout => "content"
  end

   protected

  def select_object
        @tramite =  Tramite.find(params[:id])
   rescue ActiveRecord::RecordNotFound
          render_404
   end

end
