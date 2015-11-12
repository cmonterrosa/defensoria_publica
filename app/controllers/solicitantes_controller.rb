######################################
# Controlador que brinda herramientas a los solicitantes
# foraneos
######################################

class SolicitantesController < ApplicationController
  require_role [:solicitante, :jefedefensor]
  
  def index
    @tramites = Tramite.find(:all, :conditions => ["solicitante_id = ?", current_user])
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_asistencia ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_recepcion ||= Time.now.strftime("%Y/%m/%d")
    @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
  end

   def search
    @tramites = Tramite.search(params[:search], current_user)
    render :partial => "list", :layout => "content"
  end

  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.update_attributes(params[:tramite])
    @tramite.solicitante_id ||= current_user.id if current_user
    if @tramite.valid?
      @tramite.save
      flash[:notice] = "Trámite registrado correctamente"
      redirect_to :action => "index"
    else
      @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
      render :action => "new_or_edit"
    end
  end

  def destroy
      success = (@tramite = Tramite.find(params[:id])) && @tramite.solicitante_id = current_user.id if current_user
      sin_asignar = (@tramite.defensor_id.nil?)? true : false
      ((success && sin_asignar)&& @tramite.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
      redirect_to :action => "index"
  end

end
