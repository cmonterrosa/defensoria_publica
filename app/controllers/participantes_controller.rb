######################################
# Controlador que administra a los participantes de cada
# trámite
######################################

class ParticipantesController < ApplicationController

  before_filter :login_required

  def index
      @tramite = Tramite.find(params[:t]) if params[:t]
      @participantes = @tramite.participantes if @tramite
      render :partial => "list", :layout => "content"
  end

  def search
    @tramite = Tramite.find(params[:t]) if params[:t]
    @participantes = Participante.search(params[:search], @tramite)
    render :partial => "list", :layout => "content"
  end

  def new_or_edit
      @participante= (params[:id])? Participante.find(params[:id]) : Participante.new
      @tramite = Tramite.find(params[:t]) if params[:t]
      @persona = @participante.persona
      @calidads= Calidad.all
      @papels = Papel.all
      @entornos = Entorno.all
      @marginacions = Marginacion.all
  end

   def save
      @tramite = (params[:t])? Tramite.find(params[:t]) : nil
      @participante = (params[:id])? Participante.find(params[:id]) : Participante.new
      @participante.update_attributes(params[:participante])
      @participante.persona = (params[:persona] && params[:persona][:per_curp]) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
      @participante.persona ||= Persona.new(params[:persona])
      @participante.privado_libertad = (params[:participante] && params[:participante][:privado_libertad] == 'SI') ? true : false
      @participante.libre_atraves_medida_cautelar = (params[:participante] && params[:participante][:libre_atraves_medida_cautelar] == 'SI') ? true : false
      @participante.libre_suspension_condicional_proceso = (params[:participante] && params[:participante][:libre_suspension_condicional_proceso] == 'SI') ? true : false
        if @tramite && @participante.valid? && @participante.persona.valid?
          @participante.save && (@tramite.participantes << @participante) && @participante.persona.save
          flash[:notice] = "Participante registrado correctamente"
          redirect_to :controller => "participantes", :t => @tramite
        else
          @papels = Papel.all
          @entornos = Entorno.all
          @calidads= Calidad.all
          @marginacions = Marginacion.all
          render :action => "new_or_edit"
        end
     end

  def destroy
    @participante = Participante.find(params[:id])
    (@participante && @participante.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "Registro no se pudo eliminar, verifique"
    redirect_to :action => "index", :t => params[:t]
  end

end
