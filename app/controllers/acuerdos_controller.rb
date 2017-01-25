###########################################################
# = Controlador que muestra acuerdos de un expediente
###########################################################
include ConexionLitigantes

class AcuerdosController < ApplicationController
  def index
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
end
