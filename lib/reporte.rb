#############################################
# = Clase que genera reporte mediante JASPER
#############################################

class Reporte
  attr_accessor :params, :options, :name
   def initialize(options={})
      @options = options
      @params = {}
   end
  
  def add_param
     @params << options unless options.empty?
  end
   

   def print
        if File.exists?(REPORTS_DIR + @name + ".jasper")
           send_doc_jdbc("ficha_atencion", "ficha_atencion", @attributes, output_type = 'pdf')
         else
           flash[:error] = "archivo de reporte no existe"
           redirect_to :controller => "home"
        end
    end
end
