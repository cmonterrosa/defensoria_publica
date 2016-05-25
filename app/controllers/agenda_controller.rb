######################################
# Controlador que visualiza en forma de calendario,
# las audiencias de oralidad
#
######################################

class AgendaController < ApplicationController

  require_role [:defensores, :jefedefensor, :admin]

  def index
     @audiencias = []
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "AGENDA DE AUDIENCIAS"
  end

    def daily_show
    @origin=params[:origin] if params[:origin]
    @type = params[:type] if params[:type]
    @token = params[:token] if params[:token]
    @audiencia = AudienciaOral.new
    if params[:year] =~ /^\d{4}$/ && params[:month] =~ /^\d{1,2}$/ && params[:day] =~ /^\d{1,2}$/
       @fecha = DateTime.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
       @horarios = AudienciaOral.find(:all, :select => "id, fecha, hora,minutos, organo_id", :conditions => ["fecha = ?", @fecha], :group => "hora,minutos")
       @before = @fecha.yesterday
       @after = @fecha.tomorrow
       @organos = Organo.find(:all, :conditions => ["id_organo in (?)", @horarios.map{|i|i.organo_id} ]) unless @horarios.empty?
       @organos ||= Array.new
    else
       redirect_to :action => @accion
    end
  end
  

end
