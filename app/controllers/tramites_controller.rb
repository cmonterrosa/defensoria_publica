######################################
# Controlador que hace operaciones basicas y conecta el tramite
# con todos los demas modelos y elementos
######################################
 
class TramitesController < ApplicationController
  require_role :defensor
  require_role :jefedefensor, :for => :asignar

  
  def index
    @tramites = Tramite.find(:all)
    render :partial => "list", :layout => "content"
  end

  def menu
    begin
      @tramite =  Tramite.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index"
    end
  end

  def new_or_edit
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_asistencia ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_recepcion ||= Time.now.strftime("%Y/%m/%d")
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true])
  end

  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.update_attributes(params[:tramite])
    if @tramite.valid?
      @tramite.save
      flash[:notice] = "Trámite registrado correctamente"
      redirect_to :controller => "tramites"
    else
      @defensores = Defensor.find(:all, :conditions => ["activo = ?", true])
      @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
      render :action => "new_or_edit"
    end
  end

  def search
    @tramites = Tramite.search(params[:search])
    render :partial => "list", :layout => "content"
  end

    def get_datos_tramite
      if params[:tramite]
        @tramite = (params[:tramite][:nuc] && params[:tramite][:nuc].size >= 4)?  Tramite.find_by_nuc(params[:tramite][:nuc]) : nil
        @tramite ||= (params[:tramite][:carpeta_investigacion] && params[:tramite][:carpeta_investigacion].size >= 4)?  Tramite.find_by_carpeta_investigacion(params[:tramite][:carpeta_investigacion]) : nil
        @tramite ||= Tramite.new
        @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
      end
      if params[:tramite][:nuc].size > 1 && params[:tramite][:carpeta_investigacion].size > 1 && params[:tramite][:defensor_id].size > 0
        return render(:partial => 'datos_tramite', :layout => false ) if request.xhr?
      else
        render :text =>""
      end
    end

   def destroy
      @tramite = Tramite.find(params[:id])
      (@tramite && @tramite.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
      redirect_to :action => "index"
   end

end
