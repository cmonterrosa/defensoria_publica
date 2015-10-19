class AudienciasController < ApplicationController
  before_filter :login_required

  def index
    @audiencias = Audiencia.find :all
  end

  def new_or_edit
      @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
  end

  def save
    @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
    @audiencia.update_attributes(params[:audiencia])
    @audiencia.persona = (params[:persona] && params[:persona][:per_curp]) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
    @audiencia.persona ||= Persona.new(params[:persona])
    if @audiencia.save && @audiencia.persona.save
      flash[:notice] = "Audiencia registrada correctamente"
      redirect_to :controller => "audiencias"
    end
  end

  def show
    @audiencia = Audiencia.find(params[:id])
  end

  def destroy
    @audiencia = Audiencia.find(params[:id])
    if @audiencia.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index"
  end

  def get_datos_personales
     if params[:persona_per_curp].size >= 15
      @persona = Persona.find(:first, :conditions => ["per_curp like ?", "#{params[:persona_per_curp]}%"])
      @persona ||= Persona.new
     end
     return render(:partial => 'datos_personales', :layout => false) if request.xhr?
  end


end
