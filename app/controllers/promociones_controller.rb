class PromocionesController < ApplicationController
	#require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @promociones = @tramite.promocions.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @promociones = Promocion.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @promocion= (params[:id])? Promocion.find(params[:id]) : Promocion.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @tipo_promocions= TipoPromocion.all
      @contestacion = Contestacion.all 
  end

  def save
    @tramite = (params[:t])? Tramite.find(params[:t]) : nil
    @promocion = (params[:id])? Promocion.find(params[:id]) : Promocion.new
    @promocion.update_attributes(params[:promocion])
    @promocion.tramite = @tramite
      
    if @tramite && @promocion.valid? 
      @promocion.save  
      flash[:notice] = "Promoción registrada correctamente"
      redirect_to :controller => "promociones", :t => @tramite
    else
      render :action => "new_or_edit"
    end
  end
end
