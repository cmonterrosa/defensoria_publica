class SentenciasController < ApplicationController
	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @sentencias = @tramite.sentencias.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @sentencias = Sentencia.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @sentencia= (params[:id])? Sentencia.find(params[:id]) : Sentencia.new
      @tramite = Tramite.find(params[:t]) if params[:t]      
      @tiposentencia= TipoSentencia.all
      
  end

  def save
    @tramite = (params[:t])? Tramite.find(params[:t]) : nil
    @sentencia = (params[:id])? Sentencia.find(params[:id]) : Sentencia.new
    @sentencia.update_attributes(params[:sentencia])
    @sentencia.tramite = @tramite
      
    if @tramite && @sentencia.valid? 
      @sentencia.save  
      flash[:notice] = "Sentencia registrada correctamente"
      redirect_to :controller => "sentencias", :t => @tramite
    else
      render :action => "new_or_edit"
    end
  end
end
