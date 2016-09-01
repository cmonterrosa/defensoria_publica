##############################################
# Script de migracion de estructura anterior de audiencias a nuevo sistema
#
##############################################

class CreateMigracions < ActiveRecord::Migration
  def self.up
        migrar_defensores
        migrar_audiencias
  end

  def self.migrar_defensores
    @inicio = Time.now
    @contador_defensores_guardados=0
    puts("=> LIMPIANDO TABLA DE DEFENSORES ") if execute("TRUNCATE defensors;")
    puts("=> CONECTADO A BD DE MIGRACION ") if Migracion.establish_connection("migracion")
    puts("=> ESTABLECIENDO  CONEXION A MODELO DEFENSOR") if Migracion.set_table_name("defensor")
    puts("=> REESTABLECIENDO ESTRUCTURA DE DEFENSORES")  if Migracion.reset_column_information
    puts("=> EXTRAYENDO CATALOGO DE DEFENSORES") if @defensores = Defensor.find(:all)
    if @defensores =Migracion.find(:all, :conditions => ["nombre not in (?)", "POR ASIGNAR"])
        puts("=> TOTAL DE DEFENSORES EN BD: #{@defensores.size}")
        puts "=> MUNICIPIO POR DEFECTO: #{@municipio.nombre}" if @municipio = Municipio.chiapas.find_by_nombre("TUXTLA GUTIERREZ")
        puts("=>ESTABLECIENDO CONEXION A MODELO DEFENSOR")  if Defensor.establish_connection("development")
        @defensores.each do |d|
              @persona = Persona.find(:first, :conditions => ["per_paterno = ? AND per_materno = ? AND per_nombre = ?", d["a_paterno"].strip, d["a_materno"].strip, d["nombre"].strip])
              @persona ||= Persona.new(:per_nombre => d["nombre"], :per_paterno => d["a_paterno"], :per_materno => d["a_materno"])
              @defensor =  Defensor.find(:first, :conditions => ["persona_id = ?", @persona.id]) if @persona
              @defensor ||= Defensor.new(:persona_id => @persona.id, :municipio_id => @municipio, :cve_def => d.cve_def, :activo => true)
              if @persona.save && @defensor.save
                puts("      DEFENSOR #{@defensor.persona.nombre_completo} GUARDADO CORRECTAMENTE")
                @contador_defensores_guardados+=1
              else
                puts("=> DEFENSOR NO SE PUDO REGISTRAR")
            end
         end
      end
      puts("=> TOTAL DE DEFENSORES ENCONTRADOS: #{@contador_defensores_guardados}")
  end

  def self.migrar_audiencias
       @total_audiencias_procesadas=0
       @total_audiencias_noprocesadas=0
       puts("LIMPIANDO AUDIENCIAS") if execute("truncate audiencias;")
       puts("=> ESTABLECIENDO MODELO AUDIENCIA") if Migracion.set_table_name("audiencia")
       puts("=> REESTABLECIENDO ESTRUCTURA DE AUDIENCIA")   if Migracion.reset_column_information
       puts("=> ESTABLECIENDO ADSCRIPCION POR DEFECTO") if @adscripcion_default = Adscripcion.find_by_clave("sugene")
       @audiencias = Migracion.find(:all, :select => "*, concat(fecha_solicitud,' ',hora) as date")
        @audiencias.each do |a|
          defensor = Defensor.find(:first, :conditions => ["cve_def = ? AND cve_def != 1", a.cve_def])
          defensor_persona = defensor.persona if defensor
          if defensor_persona
            if sol = Migracion.new
              sol.solicitante(a.cve_sol)
              #puts("=> SOLICITANTE_PERSONA: #{sol.nombre} #{sol.paterno} #{sol.materno}")
              if (sol.nombre_completo) && (encontrada = Persona.search(sol.nombre_completo))
                 #puts("=> PERSONA ENCONTRADA EN BD: #{encontrada.first.nombre_completo}")
                 solicitante_persona = (encontrada)? encontrada.first : nil if (sol.nombre_completo && sol.nombre_completo.size > 5)
              else
                puts("=> NO SE ENCONTRO EN BD: #{sol.nombre_completo}")
             end
              solicitante_persona ||= Persona.new(:per_nombre => sol.nombre, :per_paterno => sol.paterno, :per_materno => sol.materno)
              if (defensor && solicitante_persona) && solicitante_persona.save
                   # INICIAMOS CAPTURA DE AUDIENCIA
                   fechahora_atencion = a.date
                   fechahora_atencion ||= Time.now
                   nueva_audiencia = Audiencia.new(:turno => a.turno,  :fechahora_atencion =>fechahora_atencion,   :defensor_id => defensor.id,
                                              :asunto => a.asunto, :observaciones => a.observacion,  :cve_aud => a.cve_aud, :persona_id => solicitante_persona.id, :adscripcion_id => @adscripcion_default.id )
                   nueva_audiencia.persona ||= solicitante_persona
                    if nueva_audiencia.save
                        @total_audiencias_procesadas+=1
                        print("                    => AUDIENCIA CREADA CORRECTAMENTE: #{sprintf( "%0.04f", (@total_audiencias_procesadas / (@audiencias.size * 1.00)) * 100.0)} % " + "\r")
                    end
                end
            else
             # puts(" => AUDIENCIA NO CAPTURADA POR AUSENCIA DE SOLICITANTE")
            end
          else
            puts("=> NO EXISTE PERSONA VINCULADA AL DEFENSOR CON cve_def: #{a.cve_def} ")
            @total_audiencias_noprocesadas+=1
          end
        end
        puts ("=> TOTAL DE AUDIENCIAS PROCESADAS: #{@total_audiencias_procesadas}")
        puts ("=> TOTAL DE AUDIENCIAS NO PROCESADAS: #{@total_audiencias_noprocesadas}")
        @fin=Time.now
        puts("=> TOTAL DE TIEMPO DE PROCESAMIENTO: #{(@fin - @inicio) / 60.0} minutos")
  end


  def self.down
    puts("=> NO TIENE ACCION REVERSIVA")
  end
end


