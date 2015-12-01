class PromocionesController < ApplicationController
	#require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @promociones = @tramite.promocions.paginate(:page => params[:page], :per_page => 25) if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @amparos = Amparo.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

end
