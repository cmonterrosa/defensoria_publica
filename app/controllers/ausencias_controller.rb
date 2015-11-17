######################################
# Controlador que hace registra, edita y elimina
# ausencias del personal
######################################

class AusenciasController < ApplicationController
   before_filter :login_required
  
  def index
    @persona = Persona.find(params[:p]) if params[:p]
    @ausencias = Ausencia.find(:all, :conditions => ["persona_id = ?", @persona.id]).paginate(:page => params[:page], :per_page => 25) if @persona
    @ausencias ||= Ausencia.find(:all).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def search
    @ausencias = Ausencia.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @ausencia = (params[:id])? Ausencia.find(params[:id]) : Ausencia.new
      @ausencia.persona = (params[:p] && @persona = Persona.find(params[:p])) ? @persona : nil
      @persona = @ausencia.persona if @ausencia.persona
      @ausencia.inicio ||= Time.now.strftime("%Y/%m/%d")
      @ausencia.fin ||= Time.now.strftime("%Y/%m/%d")
      @motivos_ausencias = MotivoAusencia.find(:all)
  end

  def save
      @ausencia = (params[:id])? Ausencia.find(params[:id]) : Ausencia.new
      @ausencia.update_attributes(params[:ausencia])
      @ausencia.persona = (params[:persona] && params[:persona][:per_curp]) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
      @ausencia.persona ||= Persona.new(params[:persona])
      @ausencia.user_id = current_user
      if @ausencia.save && @ausencia.persona.save
        flash[:notice] = "Ausencia registrada correctamente"
        redirect_to :controller => "ausencias", :p => params[:p]
      end
  end

  def destroy
    @ausencia = Ausencia.find(params[:id])
    if @ausencia.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index", :p => params[:p]
  end

  

end
