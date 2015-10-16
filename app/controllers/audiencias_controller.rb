class AudienciasController < ApplicationController
  before_filter :login_required

  def index
    
  end

  def new_or_edit
      @audiencia = (params[:id])? Audiencia.find(params[:id]) : Audiencia.new
  end


end
