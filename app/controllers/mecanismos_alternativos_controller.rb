class MecanismosAlternativosController < ApplicationController
	#require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @mecanismos_alternativos = @tramite.mecanismo_alternativos.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  
 def search
   @tramite = Tramite.find(params[:t]) if params[:t]
   @mecanismos_alternativos = MecanismoAlternativo.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
   render :partial => "list", :layout => "content"
 end

 def new_or_edit
      @mecanismo_alternativo= (params[:id])? MecanismoAlternativo.find(params[:id]) : MecanismoAlternativo.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @tipo_mecanismo= TipoMecanismo.all      
  end

  def save
    @tramite = (params[:t])? Tramite.find(params[:t]) : nil
    @mecanismos_alternativos = (params[:id])? MecanismoAlternativo.find(params[:id]) : MecanismoAlternativo.new
    @mecanismos_alternativos.update_attributes(params[:mecanismo_alternativo])
    @mecanismos_alternativos.tramite = @tramite
      
    if @tramite && @mecanismos_alternativos.valid? 
      @mecanismos_alternativos.save  
      flash[:notice] = "Datos de mecanismo alternativo registrados correctamente"
      redirect_to :controller => "mecanismos_alternativos", :t => @tramite
    else
      render :action => "new_or_edit"
    end
  end
end
