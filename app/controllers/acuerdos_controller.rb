###########################################################
# = Controlador que muestra acuerdos de un expediente
###########################################################
include ConexionLitigantes

class AcuerdosController < ApplicationController
  def index
    @tramite = Tramite.find(params[:t]) if params[:t]
    if @tramite 
      @numero_expediente = @tramite.numero_expediente
      @acuerdos  =  ConexionLitigantes.execute(:expediente => @numero_expediente,
        :id_juzgado => 2,
        :fecha => nil,
        :email => "naylu241205@yahoo.com.mx",
        :login=>"azucena",
        :pwd=>"azucena" )
     @acuerdos = @acuerdos.paginate(:page => params[:page], :per_page => 25) if @acuerdos
    end
    @acuerdos ||= Array.new
    render :partial => "list", :layout => "content"
  end

   def list_by_expediente
    server = "172.20.60.8"
    url="http://#{server}/pruebas_general/rest/ServiciosLitigantes.php?"
    method="url=InformaAudiencias"
    response = RestClient.post  url+method,  {:expediente => "1183/2010",
        :id_juzgado => 2,
        :fecha => nil,
        :email => "naylu241205@yahoo.com.mx",
        :login=>"azucena",
        :pwd=>"azucena"	}
        @acuerdos= JSON.parse(response)
        render :partial => "list", :layout => "content"
    end

   def list
     @acuerdos  =  ConexionLitigantes.execute(:expediente => "1185/2010",
        :id_juzgado => 2,
        :fecha => nil,
        :email => "naylu241205@yahoo.com.mx",
        :login=>"azucena",
        :pwd=>"azucena"	)
     (@acuerdos) ? (render :partial => "list", :layout => "content") : (flash[:error] = 'No se encontró información de expediente' ;  redirect_back_or_default("/"))
   end

  def reporte_servicio
    server = "172.20.254.18:85"
    url="http://#{server}/retenciones/procedimientoimprimir.asmx?WSDL"
    method="procedimientoimprimir.asmx?WSDL"
    response = RestClient.post  url+method,  {:enlace => "1183/2010", :ejercicio => 2}
        @acuerdos= JSON.parse(response)
        render :partial => "list", :layout => "content"
  end

end
