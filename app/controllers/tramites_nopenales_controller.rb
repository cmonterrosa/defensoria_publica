################################################
# Controlador que hace operaciones basicas, inicia registro y conecta el tramite
# con todos los demas modelos y elementos en materias no penal 
################################################
class TramitesNopenalesController < ApplicationController
  require_role [:defensor, :jefedefensor]
  require_role :jefedefensor, :for => [:asignar, :history]

  def index
    @defensor = Defensor.nopenal.find(:first, :conditions => ["persona_id = ?", current_user.persona.id]) if current_user
    @tramites = Tramite.nopenal.find(:all, :order => "created_at DESC", :conditions => ["defensor_id = ?",  @defensor.id]).paginate(:page => params[:page], :per_page => 25) if @defensor
    @tramites = Tramite.nopenal.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    @tramites ||= Tramite.nopenal.find(Atencion.find(:all, :conditions => ["user_id = ? AND activa IS NOT NULL", current_user ]).map{|i|i.tramite_id}).paginate(:page => params[:page], :per_page => 25) if current_user.has_role?(:defensorapoyo)
    render :partial => "list", :layout => "content"
  end

   # Metodo que crea o recupera un registro
  def new_or_edit
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.new
    @numero_expediente = @tramite.numero_expediente if @tramite
    @tramite.fechahora_atencion ||= Time.now.strftime("%Y/%m/%d")
    @materias = Materia.nopenal.all
    @organos = Organo.juzgados_familiares + Organo.juzgados_civiles + Organo.salas_civiles + Organo.salas_familiares
    @tipos_juicios = TipoJuicio.all
    @defensores = Defensor.nopenal.find(:all, :conditions => ["activo = ? AND persona_id = ?", true, current_user.persona.id]) if current_user.has_role?(:defensor)
    @defensores = Defensor.nopenal.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin) || current_user.has_role?(:jefedefensor)
    @defensores ||= Array.new
  end

  # Busqueda
  def search
    @tramites = Tramite.nopenal.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def save
    @tramite = (params[:id])? Tramite.find(params[:id]) : Tramite.nopenal.new
    @tramite.init_journal(current_user) if current_user
    @tramite.update_attributes(params[:tramite])
    if @tramite.valid?
       @tramite.save
       @tramite.verificar_registro_atencion(current_user) if current_user
       @tramite.update_estatus!('tramre', current_user) if current_user
       flash[:notice] = "Trámite no penal registrado correctamente"
       redirect_to :controller => "tramites_nopenales"
    else
      @defensores = Defensor.nopenal.find(:all, :conditions => ["activo = ? AND id = ?", true, current_user.id])
      @defensores = Defensor.nopenal.find(:all, :conditions => ["activo = ?", true]) if current_user.has_role?(:admin)
      render :action => "new_or_edit"
    end
  end

    # Habilita seleccion de optiones para concluir tramite
  def options_concluir
      select_object
      @concluido = Concluido.find(:first, :conditions => ["tramite_id = ?", @tramite.id]) if @tramite
      @concluido ||= Concluido.new(:tramite_id => @tramite.id)
      @motivos_conclusion = MotivoConclusion.nopenal.all
      render :partial => "options_concluir", :layout => "content"
  end

    # Guarda trámite nopenal como concluido
  def concluir
      @tramite = Tramite.find(params[:id])
      @concluido = Concluido.find(:first, :conditions => ["tramite_id = ?", @tramite.id]) if @tramite
      @concluido ||= Concluido.new(:tramite_id => @tramite.id)
      @concluido.update_attributes(params[:concluido])
      # Options #
      @concluido.user = current_user
      if @concluido.save && @tramite.save
        redirect_to :action => "index"
        write_log("Expediente nopenal concluido correctamente: #{@concluido.inspect}", current_user)
        flash[:notice] = "Expediente concluido correctamente"
      else
        render :text => "No se pudo concluir"
        flash[:error] = "No se pudo concluir correctamente"
      end
    end


   def get_datos_tramite
        if params[:tramite]
          @organo = Organo.find(params[:tramite][:organo_id]) if params[:tramite][:organo_id] && params[:tramite][:organo_id] =~ /\d{1,5}/
          @materia = Materia.find(params[:tramite][:materia_id]) if params[:tramite][:materia_id] && params[:tramite][:materia_id] =~ /\d{1,5}/
          @defensor = Defensor.find(params[:tramite][:defensor_id]) if params[:tramite][:defensor_id] && params[:tramite][:defensor_id] =~ /\d{1,5}/
          @folio, @anio = (params[:busqueda][:numero_expediente] && params[:busqueda][:numero_expediente] =~ /\d{1,5}\/20\d{2}/ ) ?  params[:busqueda][:numero_expediente].split("/")  : nil
          if  @organo && (@folio && @anio)
              @tramite = Tramite.nopenal.find(:first, :conditions => ["(anio = ? AND folio_expediente = ?) AND organo_id = ?", @anio, @folio, @organo.id] )
          end
          @defensores = Defensor.nopenal.all
          @materias = Materia.nopenal.all
          @tipos_juicios = TipoJuicio.all
          @tramite ||= Tramite.nopenal.new
          @tramite.anio = @anio if @tramite
          @tramite.folio_expediente = @folio if @tramite
          return render(:partial => 'datos_tramite', :layout => 'only_jquery' ) if request.xhr?
        end
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

  def show
      select_object
  end

  protected

  def select_object
        @tramite =  Tramite.find(params[:id])
   rescue ActiveRecord::RecordNotFound
          render_404
   end

end
