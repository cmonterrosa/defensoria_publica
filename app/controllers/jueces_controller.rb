######################################
# Controlador que administra a los jueces
# 
######################################

class JuecesController < ApplicationController
  require_role :defensor
  require_role :admin, :for => :destroy

  def index
      @jueces = Juez.find(:all).paginate(:page => params[:page], :per_page => 25)
      @organos = Organo.all
      render :partial => "list", :layout => "content"
  end

  def search
    @jueces = Juez.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @juez = (params[:id])? Juez.find(params[:id]) : Juez.new
      @persona = @juez.persona
      @organos = Organo.all
  end

   def save
      @juez = (params[:id])? Juez.find(params[:id]) : Juez.new
      @juez.update_attributes(params[:juez])
      if params[:persona]
        @juez.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @juez.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
      end
      @juez.persona ||= Persona.new(params[:persona])
      @juez.activo = (params[:juez] && params[:juez][:activo] == 'SI') ? true : false
      if @juez.valid? && @juez.persona.valid?
         @juez.save && @juez.persona.save
         flash[:notice] = "Juez registrado correctamente"
         redirect_to :controller => "jueces"
      else
         @organos = Organo.all
         render :action => "new_or_edit"
      end
    end

  def destroy
    @juez = Juez.find(params[:id])
    (@juez && @juez.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
    redirect_to :action => "index"
  end

  def list_audiencias
    begin
      @juez = Juez.find(params[:id])
      @audiencias =  AudienciaOral.find(:all, :conditions => ["juez_id = ?", @juez]).paginate(:page => params[:page], :per_page => 25)
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index", :controller => "jueces"
    end
      
  end

end
