##########################################
# Controlador que hace operaciones basicas y conecta el tramite
# con todos los demas modelos y elementos
##########################################
 
class TramitesController < ApplicationController
  require_role :defensor
  require_role :jefedefensor, :for => :asignar

  
  def index
    @tramites = Tramite.find(:all, :conditions => ["defensor_id = ?", current_user.id]).paginate(:page => params[:page], :per_page => 25)
    @tramites = Tramite.find(:all).paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:admin)
    render :partial => "list", :layout => "content"
  end

  def menu
    begin
        @tramite =  Tramite.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index"
    end
  end

   def history
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
    @defensores = Defensor.find(:all, :conditions => ["activo = ? AND id = ?", true, current_user.id])
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin)
  end

  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.init_journal(current_user)
    @tramite.update_attributes(params[:tramite])
    if @tramite.valid?
      @tramite.save
      #@tramite.crear_modificaciones
      flash[:notice] = "Trámite registrado correctamente"
      redirect_to :controller => "tramites"
    else
      @defensores = Defensor.find(:all, :conditions => ["activo = ? AND id = ?", true, current_user.id])
      @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin)
      @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
      render :action => "new_or_edit"
    end
  end

  def search
    @tramites = Tramite.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

    def get_datos_tramite
        if params[:tramite]
        @tramite = (params[:tramite][:nuc] && params[:tramite][:nuc].size >= 3)?  Tramite.find_by_nuc(params[:tramite][:nuc]) : nil
        @tramite ||= (params[:tramite][:carpeta_investigacion] && params[:tramite][:carpeta_investigacion].size >= 3)?  Tramite.find_by_carpeta_investigacion(params[:tramite][:carpeta_investigacion]) : nil
        @tramite ||= (params[:tramite][:causa_penal] && params[:tramite][:causa_penal].size >= 3)?  Tramite.find_by_causa_penal(params[:tramite][:causa_penal]) : nil
        @tramite ||= (params[:tramite][:registro_atencion] && params[:tramite][:registro_atencion].size >= 3)?  Tramite.find_by_registro_atencion(params[:tramite][:registro_atencion]) : nil
        @tramite ||= Tramite.new
        @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
        end
        return render(:partial => 'datos_tramite', :layout => false ) if request.xhr?
     end
   

   def destroy
      @tramite = Tramite.find(params[:id])
      (@tramite && @tramite.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
      redirect_to :action => "index"
   end

end
