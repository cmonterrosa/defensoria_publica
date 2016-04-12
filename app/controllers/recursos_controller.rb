class RecursosController < ApplicationController
	#require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @recursos = @tramite.recursos.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @recursos = Recurso.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @recurso= (params[:id])? Amparo.find(params[:id]) : Recurso.new
      @tramite = Tramite.find(params[:t]) if params[:t]      
      @tiporecurso= TipoRecurso.all
      
  end

  def save
    @tramite = (params[:t])? Tramite.find(params[:t]) : nil
    @recurso = (params[:id])? Recurso.find(params[:id]) : Recurso.new
    @recurso.update_attributes(params[:recurso])
    @recurso.tramite = @tramite
      
    if @tramite && @recurso.valid? 
      @recurso.save  
      flash[:notice] = "Recurso registrado correctamente"
      redirect_to :controller => "recursos", :t => @tramite
    else
      render :action => "new_or_edit"
    end
  end

end
