class AmparosController < ApplicationController
	require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @amparos = @tramite.amparos.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @amparos = Amparo.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @amparo= (params[:id])? Amparo.find(params[:id]) : Amparo.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @tipo_amparos= TipoAmparo.all
      @resoluciones_amparos = Catalogo.sentido_resolucion_amparo.all 
      
  end

  def save
    @tramite = (params[:t])? Tramite.find(params[:t]) : nil
    @amparo = (params[:id])? Amparo.find(params[:id]) : Amparo.new
    @amparo.update_attributes(params[:amparo])
    @amparo.tramite = @tramite
      
    if @tramite && @amparo.valid? 
      @amparo.save  
      flash[:notice] = "Amparo registrado correctamente"
      redirect_to :controller => "amparos", :t => @tramite
    else
      @tipo_participantes = TipoParticipante.all
      @entornos = Entorno.all
      @calidads= Calidad.all
      @marginacions = Marginacion.all
      render :action => "new_or_edit"
    end
  end

  def destroy
    @amparo = Amparo.find(params[:id])
    (@amparo && @amparo.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
    redirect_to :action => "index", :t => params[:t]
  end

end
