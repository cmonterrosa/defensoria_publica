##########################################
# Controlador que administra a los participantes de cada
# trámite
###########################################

class ParticipantesController < ApplicationController

  require_role [:jefedefensor, :defensorpenal, :defensorapoyo], :for_all_except => :show

  def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @participantes = @tramite.participantes.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @participantes = Participante.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @participante= (params[:id])? Participante.find(params[:id]) : Participante.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @tramite ||= @participante.tramite
      @persona = @participante.persona
      @calidads= Calidad.all
      @tipo_participantes = TipoParticipante.all
      @entornos = Entorno.all
      @marginacions = Marginacion.all
      @edo_civil = Catalogo.estado_civil.all
      @escolaridades = Catalogo.escolaridad.all
  end

  def save
     @tramite = (params[:t])? Tramite.find(params[:t]) : nil
     @participante = (params[:id])? Participante.find(params[:id]) : Participante.new
     @participante.init_journal(current_user)
     @tramite ||= @participante.tramite if @participante && @participante.tramite
     @participante.update_attributes(params[:participante])
     save_persona(params, @participante)
      @participante.persona ||= Persona.new(params[:persona])
      @participante.tramite ||= @tramite
      @participante.privado_libertad = (params[:participante] && params[:participante][:privado_libertad] == 'SI') ? true : false
      @participante.libre_atraves_medida_cautelar = (params[:participante] && params[:participante][:libre_atraves_medida_cautelar] == 'SI') ? true : false
      @participante.libre_suspension_condicional_proceso = (params[:participante] && params[:participante][:libre_suspension_condicional_proceso] == 'SI') ? true : false
        if @tramite && @participante.valid? && @participante.persona.valid?
          @participante.save && @participante.tramite.save &&  @participante.persona.save
          flash[:notice] = "Participante registrado correctamente"
          redirect_to :controller => "participantes", :t => @tramite
        else
          @tipo_participantes = TipoParticipante.all
          @entornos = Entorno.all
          @calidads= Calidad.all
          @marginacions = Marginacion.all
          @edo_civil = Catalogo.estado_civil.all
          render :action => "new_or_edit"
        end
  end

  def get_campos_especificos
    if params[:tipo_participante]
      @tipo_participantes = TipoParticipante.all
      @edo_civil = Catalogo.estado_civil.all 
      @escolaridades = Catalogo.escolaridad.all
      @calidads= Calidad.all
      @participante= (params[:id])? Participante.find(params[:id]) : Participante.new
      @marginacions = Marginacion.all
      @entornos = Entorno.all
      @defensores = Defensor.find(:all, :conditions => "activo IS NOT NULL or activo !=0")
      @corporaciones_policiacas = CorporacionPoliciaca.all
      @municipios = Municipio.chiapas.all
      @tipo_participante = TipoParticipante.find(params[:tipo_participante])
      render :partial => @tipo_participante.default_partial, :layout => "only_javascript"
    else
      render :text => "Error"
    end
  end

  def history
      select_object
  end

  def show
    select_object
    @tipo_participantes = TipoParticipante.all
    @edo_civil = Catalogo.estado_civil.all
    @escolaridades = Catalogo.escolaridad.all
    @calidads= Calidad.all
    @marginacions = Marginacion.all
    @entornos = Entorno.all
    @defensores = Defensor.find(:all, :conditions => "activo IS NOT NULL or activo !=0")
    @corporaciones_policiacas = CorporacionPoliciaca.all
    @municipios = Municipio.chiapas.all
  end

  def destroy
    @participante = Participante.find(params[:id])
    @destroyed = @participante.dup if @participante
    if @participante && @participante.destroy
         flash[:notice] = "Registro eliminado correctamente"
         write_log("Participante eliminado: #{@destroyed.inspect}", current_user)
    else
         flash[:error] = "Registro no se pudo eliminar, verifique"
    end
    redirect_to :action => "index", :t => params[:t]
  end


  ###########################################
  # Relaciones de parentesco entre participantes
  #
  ###########################################

  def relationships
    @participante = (params[:id])? Participante.find(params[:id]) : nil
    @tramite = @participante.tramite if @participante
    @participantes = Participante.find(:all, :conditions => ["tramite_id = ? AND id not in (?)", @participante.tramite_id, @participante.id]) if @participante
    @relacion = Relacion.new
    @relaciones = Catalogo.parentesco.all
    render :partial => "relationships", :layout => "content"
  end

  def destroy_relationship
    @relacion = Relacion.find(params[:id])
    @participante = @relacion.participante
    if @relacion.destroy
      flash[:notice] = "Registro eliminado correctamente"
      redirect_to :action => "relationships", :id => @participante
    else
      flash[:error] = "Registro no se pudo eliminar"
      render :action =>"relationships"
    end
  end


  def save_relationships
   if @participante = Participante.find(params[:id])
      @segundo_participante = Participante.find(params[:relacion][:segundo_participante_id]) if @participante && params[:relacion][:segundo_participante_id]
      if @segundo_participante && !params[:relaciones].empty?
          params[:relaciones].each_key do |k|
              if (Relacion.create(:participante_id => @participante.id, :segundo_participante_id => @segundo_participante.id, :parentesco_id => k.to_i) unless Relacion.count(:id, :conditions => ["(participante_id = ? OR segundo_participante_id = ? )AND parentesco_id = ?", @participante.id, @segundo_participante.id, k.to_i]) > 0)
                  flash[:notice] = "Parentesco guardado correctamente"
              end
          end
      else
        flash[:warning] = "Se requiere seleccionar al participante y al menos un parentesco"
      end
        redirect_to :action => "relationships", :id => @participante
    else
      flash[:error] = "No se encontro participante, contacte al administrador"
      redirect_to :controller => "home"
    end
  end

  protected

    def select_object
      @participante =  Participante.find(params[:id])
    rescue ActiveRecord::RecordNotFound
          render_404
          #flash[:error] = "No se encontro tramite, verifique o contacte al administrador"
          #redirect_to  :action => "index"
   end
end
