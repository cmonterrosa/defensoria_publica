################################################
# Controlador que hace operaciones basicas, inicia registro y conecta el tramite
# con todos los demas modelos y elementos en materias penal (NSJP)
################################################
 
class TramitesController < ApplicationController
  require_role [:defensorpenal, :jefedefensor, :defensorapoyo]
  require_role :jefedefensor, :for => [:asignar, :history]

  
  # Listado general del tramites penales
  def index
    @defensor = Defensor.penal.find(:first, :conditions => ["persona_id = ?", current_user.persona.id]) if current_user
    @tramites = Tramite.penal.find(:all, :order => "created_at DESC", :conditions => ["defensor_id = ?", @defensor.id]).paginate(:page => params[:page], :per_page => 25) if @defensor
    @tramites = Tramite.penal.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    @tramites ||= Tramite.penal.find(Atencion.find(:all, :conditions => ["user_id = ? AND activa IS NOT NULL", current_user ]).map{|i|i.tramite_id}).paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:defensorapoyo)
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

  # Habilita seleccion de optiones para concluir tramite
  def options_concluir
      select_object
      @concluido = Concluido.find(:first, :conditions => ["tramite_id = ?", @tramite.id]) if @tramite
      @concluido ||= Concluido.new(:tramite_id => @tramite.id)
      @motivos_conclusion = MotivoConclusion.all
      render :partial => "options_concluir", :layout => "content"
  end

  # Despliega opciones de seleccion al concluir tramite
  def get_opciones
    if @motivo_conclusion = MotivoConclusion.find(params[:concluido][:motivo_conclusion_id])
        case @motivo_conclusion.clave
        when 'poralt'
          @mecanismo_alternativo = MecanismoAlternativo.find(:first, :conditions => ["tramite_id = ?", params[:tramite][:id]]) || MecanismoAlternativo.new
          @tipo_mecanismo= TipoMecanismo.all
          render :partial => "options_for_mecanismos_alternativos"
        else
          render :text => ""
        end
    end
  end

  # Guarda trámite como concluido
  def concluir
      @tramite = Tramite.find(params[:id])
      @concluido = Concluido.find(:first, :conditions => ["tramite_id = ?", @tramite.id]) if @tramite
      @concluido ||= Concluido.new(:tramite_id => @tramite.id)
      @concluido.update_attributes(params[:concluido])
      # Options #
      @mecanismo_alternativo = MecanismoAlternativo.find(:first, :conditions => ["tramite_id = ?", params[:tramite][:id]]) || MecanismoAlternativo.new(params[:mecanismo_alternativo] )
      @tramite.mecanismo_alternativos << @mecanismo_alternativo
      @concluido.user = current_user
      if @concluido.save && @tramite.save
        redirect_to :action => "index"
        write_log("Expediente concluido correctamente: #{@concluido.inspect}", current_user)
        flash[:notice] = "Expediente concluido correctamente"
      else
        render :text => "No se pudo concluir"
        flash[:error] = "No se pudo concluir correctamente"
      end
    end

  # Metodo que crea o recupera un registro
  def new_or_edit
    @tramite = (params[:id])? Tramite.penal.find(params[:id]) : Tramite.penal.new
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @materias = Catalogo.materia.all
    @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
    @defensores = Defensor.find(:all, :conditions => ["activo = ? AND persona_id = ?", true, current_user.persona.id]) if current_user.has_role?(:defensor)
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    @defensores ||= Array.new
  end

  def new_or_edit_apoyo
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @materias = Catalogo.materia.all
    @fiscalias = Fiscalia.find(:all, :conditions => ["activa = ?", true])
    @defensores = Defensor.find(:all, :conditions => ["activo = ? AND persona_id = ?", true, current_user.persona.id]) if current_user.has_role?(:defensor)
    @defensores = Defensor.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    @defensores ||= Array.new
    render :partial => "new_or_edit_apoyo", :layout => "content"
  end

  # Metodo que guarda el registro
  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @tramite.init_journal(current_user) if current_user
    @tramite.update_attributes(params[:tramite])
    #@tramite.prepare_fields
    if @tramite.valid?
       @tramite.save
       @tramite.verificar_registro_atencion(current_user) if current_user
       @tramite.update_estatus!('tramre',current_user) if current_user
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
      @tramite = Tramite.penal.find(params[:id])
      (@tramite && @tramite.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
      redirect_to :action => "index"
   end

   def notificar
     if select_object
      @user = User.find_by_login(Base64.decode64(params[:token])) if params[:token]
      if (@user && @user == current_user) && (@user.has_role?(:jefedefensor) || @user.has_role?(:defensorapoyo))
          render :partial => "notificacion_email", :layout => "content"
      else
          flash[:error] = "No tiene privilegios de notificar (Aplica unicamente para materia penal)"
          redirect_to :controller => "home"
      end
     end
   end

   def send_notification
     select_object
     if @tramite.notificar_por_email
        flash[:notice] = "Envío correcto"
        redirect_to(:back)
     end
   end

 protected
  
  def select_object
    begin
      @tramite =  Tramite.penal.find(params[:id])
    rescue ActiveRecord::RecordNotFound
          render_404
    end
  end
end
