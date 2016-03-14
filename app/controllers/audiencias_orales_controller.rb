###########################################
#  Controlador que administra las acciones básicas de
#  las audiencias inicial, intermedia y   de juicio oral
#############################################

class AudienciasOralesController < ApplicationController
  require_role :defensor, :for_all_except => :show
  
  def index
    @tramite = Tramite.find(params[:t]) if params[:t]
    @audiencias = @tramite.audiencia_orals
    render :partial => "list", :layout => "content"
  end

  def search
    @audiencias =AudienciaOral.search(params[:search])
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @audiencia = (params[:id])? AudienciaOral.find(params[:id]) : AudienciaOral.new
      @tipos_audiencias = TipoAudiencia.all
      @organos = Organo.all
      @jueces = Juez.find(:all, :conditions => ["activo = ?", true])
      if current_user.has_role?(:admin)
          @defensores ||= Defensor.find(:all, :conditions => ["activo = ?", true])
      elsif current_user.has_role?(:defensor)
        @defensores = Defensor.find(:all, :conditions => ["persona_id = ?", current_user.persona.id]) if current_user.persona
      end
      @defensores ||= Defensor.find(:all, :conditions => ["activo = ?", true])
      @audiencia.fecha ||= Time.now.strftime("%Y/%m/%d")
      @tramite = @audiencia.tramite if @audiencia
      @tramite ||= Tramite.find(params[:t]) if params[:t]
  end

    def save
      @audiencia = (params[:id])? AudienciaOral.find(params[:id]) : AudienciaOral.new
      @audiencia.update_attributes(params[:audiencia])
      @tramite = Tramite.find(params[:t]) if params[:t]
      @audiencia.tramite = (@tramite) ? @tramite : Tramite.new
      if @audiencia.save && @audiencia.tramite.save
        flash[:notice] = "Audiencia registrada correctamente"
        redirect_to :controller => "audiencias_orales", :t => @tramite
      else
        flash[:error] = "Registro no válido"
        render :action => "new_or_edit"
      end
  end

  def destroy
    @audiencia = AudienciaOral.find(params[:id])
    @tramite = @audiencia.tramite if @audiencia
    @tramite ||= Tramite.find(params[:t]) if params[:t]
    if @audiencia.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index", :t => @tramite
  end

    def show
      @audiencia = AudienciaOral.find(params[:id])
      @tramite = @audiencia.tramite if @audiencia
      @tramite ||= Tramite.find(params[:t]) if params[:t]
    end

    ########################################
    # Acciones que se llaman desde la vista de calendario
    #
    ########################################

    def show_window
      @audiencia = AudienciaOral.find(params[:id])
      @tramite = @audiencia.tramite if @audiencia
      @tramite ||= Tramite.find(params[:t]) if params[:t]
      render :partial => "show", :layout => "only_javascript"
    end

    def cancel_window
      @audiencia = AudienciaOral.find(params[:id])
      @tramite = @audiencia.tramite if @audiencia
      @tramite ||= Tramite.find(params[:t]) if params[:t]
      if @audiencia.cancelar(current_user)
        flash[:notice] = "Audiencia cancelada correctamante"
      else
        flash[:error] = "No se pudo cancelar, verifique"
      end
      render :partial => "show", :layout => "only_javascript"
    end

     def reactivar_window
      @audiencia = AudienciaOral.find(params[:id])
      @tramite = @audiencia.tramite if @audiencia
      @tramite ||= Tramite.find(params[:t]) if params[:t]
      if @audiencia.reactivar
        flash[:notice] = "Audiencia reactivada correctamante"
      else
        flash[:error] = "No se pudo reactivar, verifique"
      end
      render :partial => "show", :layout => "only_javascript"
    end

end
