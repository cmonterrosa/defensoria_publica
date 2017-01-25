###########################################################
# = Módulo que se conecta a aplicación de Litigantes y muestra información sobre expedientes
###########################################################
require 'rest-client'
require 'json'

module ConexionLitigantes
    
  def execute(options={})
        method="url=InformaAudiencias"
        get_config()
        begin
            response = RestClient.post  @config[:url] + method, options
            return  JSON.parse(response)
        rescue RuntimeError => e
                puts e
        end
  end
  
  protected
  # Obtiene parámetros de configuracion
  def get_config
        @environment = ENV['RAILS_ENV'] || 'development'
        @config_file = YAML.load(File.read('config/database.yml'))
        @config ||= {}
        @config[:host] = @config_file[@environment]['litigantes_host']
        @config[:url] = (@config_file[@environment]['litigantes_url'])?  "http://#{@config[:host] }/" + @config_file[@environment]['litigantes_url'] : nil
    end
end
