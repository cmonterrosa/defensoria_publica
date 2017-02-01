#Dir.getwd
require 'rubygems'
require 'os'


class Document
  include RbConfig
  def self.generate_report_xml(ds_data, report_design, output_type, select_criteria, report_params)
       report_design << '.jasper' if !report_design.match(/\.jasper$/)
       interface_classpath=RAILS_ROOT+"/app/jasper/bin"
       
       if OS.windows?   #=> true or false
          mode = "w+b" #windows requires binary mode
          Dir.foreach(RAILS_ROOT+"/app/jasper/lib") do |file|
            interface_classpath << ";#{RAILS_ROOT}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
          end
       else
         mode = "w+"
          Dir.foreach(RAILS_ROOT+"/app/jasper/lib") do |file|
            interface_classpath << ":#{RAILS_ROOT}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
          end
        end
        result=nil
		    IO.popen "java -Djava.awt.headless=true -cp \"#{interface_classpath}\" XmlJasperInterface -o#{output_type} -f#{RAILS_ROOT}/app/reports/#{report_design} #{report_params} -x#{select_criteria}", mode do |pipe|
			  pipe.write ds_data
			  pipe.close_write
			  result = pipe.read
			  pipe.close
        end

     return result
  end

  # Envía datos mediante conexión jdbc a JasperReports
  def self.generate_report_jdbc(report_design, output_type, report_params)
      report_design << '.jasper' if !report_design.match(/\.jasper$/)
       if OS.windows?   #=> true or false
          interface_classpath=RAILS_ROOT+"\\app\\jasper\\bin"
          mode = "w+b" #windows requires binary mode
          report_url="#{RAILS_ROOT}\\app\\reports\\#{report_design}"
          Dir.foreach(RAILS_ROOT+"\\app\\jasper\\lib") do |file|
            interface_classpath << ";#{RAILS_ROOT}\\app\\jasper\\lib\\" + file if (file != '.' and file != '..' and file.match(/.jar/))
         end
       else
         interface_classpath=RAILS_ROOT+"/app/jasper/bin"
         mode = "w+"
         report_url="#{RAILS_ROOT}/app/reports/#{report_design}"
         Dir.foreach(RAILS_ROOT+"/app/jasper/lib") do |file|
            interface_classpath << ":#{RAILS_ROOT}/app/jasper/lib/" + file if (file != '.' and file != '..' and file.match(/.jar/))
         end
        end
        results=nil
        config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'database.yml'))[RAILS_ENV]
        host, database, username, password, port = config['host'], config['database'], config['username'], config['password'], config['port']
        case config['adapter']
        when "mysql"
          jdbc_driver = "com.mysql.jdbc.Driver"
           port="3306" if port.nil?
        when "postgresql"
          jdbc_driver = "org.postgresql.Driver"
        end

        jdbc_url= "jdbc:#{config['adapter']}://#{host}:#{port}/#{database}"
        exec_string = "java -Djava.awt.headless=true -cp \"#{interface_classpath}\" XmlJasperInterface -Duser.language=es -Duser.region=MX -o#{output_type} -f#{report_url} #{report_params} -d\"#{jdbc_driver}\" -u\"#{jdbc_url}\" -n\"#{username}\" -p\"#{password}\""
	      
        IO.popen(exec_string, mode) do |pipe|
          results = pipe.read
          pipe.close
        end
        
        #puts exec_string
        #IO.popen(exec_string, "r+") do |pipe|
	       # results = pipe.read
	        #pipe.close
	      #end
     puts results
    return results
  end
end


