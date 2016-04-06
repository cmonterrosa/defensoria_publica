######################################
# Controlador que administra a los participantes de cada
# trámite
######################################

class ParticipantesController < ApplicationController

  require_role :defensor, :for_all_except => :show

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
      @persona = @participante.persona
      @calidads= Calidad.all
      @tipo_participantes = TipoParticipante.all
      @entornos = Entorno.all
      @marginacions = Marginacion.all
  end

  def save
     @tramite = (params[:t])? Tramite.find(params[:t]) : nil
     @participante = (params[:id])? Participante.find(params[:id]) : Participante.new
     @participante.init_journal(current_user)
     @participante.update_attributes(params[:participante])
      if params[:persona]
        @participante.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
        @participante.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
        ## Si no existe vamos a crear el objeto persona ##
        @participante.persona ||= Persona.new(:per_nombre => params[:persona][:per_nombre], :per_paterno => params[:persona][:per_paterno], :per_materno => params[:persona][:per_materno])
        if params[:contacto]
            @participante.persona.set_datos_contacto('telefono_celular', :con_parametro => params[:contacto][:telefono_celular], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_celular] &&  params[:contacto][:telefono_celular].size > 0
            @participante.persona.set_datos_contacto('telefono_casa', :con_parametro => params[:contacto][:telefono_casa], :con_usu_modi => current_user.persona.id) if params[:contacto][:telefono_casa] &&  params[:contacto][:telefono_casa].size > 0
            @participante.persona.set_datos_contacto('direccion', :con_parametro => params[:contacto][:direccion], :con_usu_modi => current_user.persona.id) if params[:contacto][:direccion] &&  params[:contacto][:direccion].size > 0
            @participante.persona.set_datos_contacto('correo_electronico', :con_parametro => params[:contacto][:correo_electronico], :con_usu_modi => current_user.persona.id) if params[:contacto][:correo_electronico] &&  params[:contacto][:correo_electronico].size > 0
         end
      end
      
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
          render :action => "new_or_edit"
        end
  end

  def get_campos_especificos
    if params[:tipo_participante]
      @tipo_participantes = TipoParticipante.all
      @edo_civil = Catalogo.estados_civiles.all 
      @escolaridades = Catalogo.escolaridades.all
      @calidads= Calidad.all
      @participante= (params[:id])? Participante.find(params[:id]) : Participante.new
      @marginacions = Marginacion.all
      @entornos = Entorno.all
      @particular = (@participante.particular) ? "SI" : "NO"
      
      case TipoParticipante.find(params[:tipo_participante]).clave
        when "MPTU"
          render :partial => "ministerio_publico", :layout => false 
        when "DEPU"
          @defensores = Defensor.find(:all, :conditions => "activo IS NOT NULL or activo !=0")
          render :partial => "defensor", :layout => false 
        when "PERI"
          render :partial => "perito", :layout => false 
        when "POLI"
          @corporaciones_policiacas = CorporacionPoliciaca.all
          render :partial => "policia", :layout => false 
        when "VICT"
          render :partial => "victima", :layout => false   
        when "ACU"
          render :partial => "acusado", :layout => false 
        when "TEST"
          render :partial => "testigo", :layout => false 
        when "DEPR"
          render :partial => "defensor_privado", :layout => false
      end
    else
    end
  end

  def history
    begin
        @participante = Participante.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index"
    end
  end

  def destroy
    @participante = Participante.find(params[:id])
    (@participante && @participante.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
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

end
