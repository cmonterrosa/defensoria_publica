##########################################
# Controlador que hace operaciones basicas, inicia registro y conecta el tramite
# con todos los demas modelos y elementos
##########################################
 
class TramitesController < ApplicationController
  require_role [:defensor, :jefedefensor]
  require_role :jefedefensor, :for => [:asignar, :history]

  
  def index
    @defensor = Defensor.find(:first, :conditions => ["persona_id = ?", current_user.persona.id]) if current_user
    @tramites = Tramite.find(:all, :order => "created_at DESC", :conditions => ["defensor_id = ?", @defensor.id]).paginate(:page => params[:page], :per_page => 25) if @defensor
    @tramites = Tramite.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    render :partial => "list", :layout => "content"
  end

  def menu
    select_object
  end

  def history
    select_object
  end
  
  def atenciones
    select_object
  end


  def new_or_edit
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_asistencia ||= Time.now.strftime("%Y/%m/%d")
    @tramite.fechahora_recepcion ||= Time.now.strftime("%Y/%m/%d")
    @defensores = Defensor.find(:all, :conditions => ["activo = ? AND persona_id = ?", true, current_user.persona.id])
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
  end

  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.init_journal(current_user) if current_user
    @tramite.update_attributes(params[:tramite])
    if @tramite.valid?
       @tramite.save
       @tramite.verificar_registro_atencion(current_user) if current_user
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

  def show
      select_object
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
        return render(:partial => 'datos_tramite', :layout => 'only_jquery' ) if request.xhr?
     end
   
   def destroy
      @tramite = Tramite.find(params[:id])
      (@tramite && @tramite.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
      redirect_to :action => "index"
   end

 protected
  
   def select_object
        begin
            @tramite =  Tramite.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            flash[:error] = "No se encontro tramite, verifique o contacte al administrador"
            redirect_to  :action => "index"
        end
   end
end
