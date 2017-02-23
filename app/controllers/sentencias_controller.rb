################################################
# = Sentencias del trámite
#
################################################

class SentenciasController < ApplicationController
  require_role [:admin, :defensor, :jefedefensor, :defensorpenal]
  
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
      if @tramite.materia == Materia.find_by_descripcion("PENAL")
        @tiposentencia= TipoSentencia.penal.all
         @organos = Organo.juzgados_control.all
         render :partial => "new_or_edit_penal", :layout => "content"
      else
        @tiposentencia= TipoSentencia.nopenal.all
        @organos = Organo.juzgados_familiares.all + Organo.salas_familiares.all
        render :partial => "new_or_edit", :layout => "content"
      end
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