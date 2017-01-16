######################################
# Controlador que administra a los amparos de cada trámite
# asimismo, carga archivos adjuntos vinculados
######################################

class AmparosController < ApplicationController
	require_role :defensor, :for_all_except => :show

	def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @amparos = @tramite.amparos.paginate(:page => params[:page], :per_page => 25) if @tramite
      if Tramite.nopenal.exists?(:id => @tramite.id)
          render :partial => "list_nopenales", :layout => "content"
      else
          render :partial => "list", :layout => "content"
      end
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @amparos = Amparo.search(params[:search], @tramite).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
    @amparo= (params[:id])? Amparo.find(params[:id]) : Amparo.new
    @tramite = Tramite.find(params[:t]) if params[:t]
    fill_combos
  end

  def save
    begin
      @tramite = (params[:t])? Tramite.find(params[:t]) : nil
      @amparo = (params[:id])? Amparo.find(params[:id]) : Amparo.new
      @amparo.update_attributes(params[:amparo])
      @amparo.tramite = @tramite
      if @tramite && @amparo.valid?
        @amparo.save && save_adjunto(@amparo)
        flash[:notice] = "Amparo registrado correctamente"
        redirect_to :controller => "amparos", :t => @tramite
      else
        fill_combos
        render :action => "new_or_edit"
      end

      rescue ActiveRecord::RecordInvalid => invalid
            flash[:error] = invalid.record.errors.full_messages
      end
  end

  def destroy
    select_object
    (@amparo && @amparo.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
    redirect_to :action => "index", :t => params[:t]
  end

  def show
    select_object
  end


 protected

  def select_object
        @amparo =  Amparo.find(params[:id])
   rescue ActiveRecord::RecordNotFound
          render_404
   end

   def fill_combos
    @acciones_amparos= AccionAmparo.all
    @tipos_amparos= TipoAmparo.all
    @fases_amparos = FaseAmparo.all
    @sentidos_resoluciones_amparos = SentidoResolucionAmparo.all
   end

end
