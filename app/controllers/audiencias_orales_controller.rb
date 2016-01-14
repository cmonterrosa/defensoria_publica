######################################
# Controlador que administra las audiencias inicial, intermedia y
# de juicio oral
######################################

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

end
