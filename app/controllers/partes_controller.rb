##########################################
# Controlador que administra a los partes de cada
# trámite no penal
###########################################

class PartesController < ApplicationController

  require_role [:jefedefensor, :defensor, :admin], :for_all_except => :show

  def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @partes = @tramite.partes.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @partes = Parte.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @parte= (params[:id])? Parte.find(params[:id]) : Parte.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @tramite ||= @parte.tramite
      @persona = @parte.persona
      @calidads= Calidad.all
      @tipo_participantes = TipoParticipante.all
      @entornos = Entorno.all
      @marginacions = Marginacion.all
      @tipos_partes = TipoParte.all
      @edo_civil = Catalogo.estado_civil.all
      @escolaridades = Catalogo.escolaridad.all
  end

  def save
     @tramite = (params[:t])? Tramite.find(params[:t]) : nil
     @parte = (params[:id])? Parte.find(params[:id]) : Parte.new
     @parte.init_journal(current_user)
     @tramite ||= @parte.tramite if @parte && @parte.tramite
     @parte.update_attributes(params[:parte])
     save_persona(params, @parte)
      @parte.persona ||= Persona.new(params[:persona])
      @parte.tramite ||= @tramite
      @parte.tipo_parte ||= TipoParte.find(params[:parte][:tipo_parte_id]) if params[:parte][:tipo_parte_id]
      if @tramite && @parte.valid? && @parte.persona.valid?
          @parte.save && @parte.tramite.save &&  @parte.persona.save
          flash[:notice] = "Parte registrada correctamente"
          redirect_to :controller => "partes", :t => @tramite
        else
          @tipo_partes = TipoParte.all
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
      @parte= (params[:id])? Participante.find(params[:id]) : Participante.new
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
    @tipos_partes = TipoParte.all
    @edo_civil = Catalogo.estado_civil.all
    @escolaridades = Catalogo.escolaridad.all
    @calidads= Calidad.all
    @marginacions = Marginacion.all
    @entornos = Entorno.all
    @defensores = Defensor.find(:all, :conditions => "activo IS NOT NULL or activo !=0")
    @municipios = Municipio.chiapas.all
  end

  def destroy
    @parte = Parte.find(params[:id])
    @destroyed = @parte.dup if @parte
    if @parte && @parte.destroy
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
    @parte = (params[:id])? Parte.find(params[:id]) : nil
    @tramite = @parte.tramite if @parte
    @partes = Participante.find(:all, :conditions => ["tramite_id = ? AND id not in (?)", @parte.tramite_id, @parte.id]) if @parte
    @relacion = Relacion.new
    @relaciones = Catalogo.parentesco.all
    render :partial => "relationships", :layout => "content"
  end

  def destroy_relationship
    @relacion = Relacion.find(params[:id])
    @parte = @relacion.parte
    if @relacion.destroy
      flash[:notice] = "Registro eliminado correctamente"
      redirect_to :action => "relationships", :id => @parte
    else
      flash[:error] = "Registro no se pudo eliminar"
      render :action =>"relationships"
    end
  end

   def history
      select_object
  end


  def save_relationships
   if @parte = Parte.find(params[:id])
      @segundo_participante = Parte.find(params[:relacion][:segundo_participante_id]) if @parte && params[:relacion][:segundo_participante_id]
      if @segundo_participante && !params[:relaciones].empty?
          params[:relaciones].each_key do |k|
              if (Relacion.create(:participante_id => @parte.id, :segundo_participante_id => @segundo_participante.id, :parentesco_id => k.to_i) unless Relacion.count(:id, :conditions => ["(participante_id = ? OR segundo_participante_id = ? )AND parentesco_id = ?", @parte.id, @segundo_participante.id, k.to_i]) > 0)
                  flash[:notice] = "Parentesco guardado correctamente"
              end
          end
      else
        flash[:warning] = "Se requiere seleccionar al participante y al menos un parentesco"
      end
        redirect_to :action => "relationships", :id => @parte
    else
      flash[:error] = "No se encontro participante, contacte al administrador"
      redirect_to :controller => "home"
    end
  end

  protected

    def select_object
      @parte =  Parte.find(params[:id])
      @persona = @parte.persona
      @persona ||= Persona.find(params[:p])
    rescue ActiveRecord::RecordNotFound
          render_404
          #flash[:error] = "No se encontro tramite, verifique o contacte al administrador"
          #redirect_to  :action => "index"
   end
end
