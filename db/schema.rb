# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160809152656) do

  create_table "adjuntos", :force => true do |t|
    t.string   "descripcion",     :limit => 160
    t.string   "file_name",       :limit => 120
    t.string   "file_size",       :limit => 25
    t.string   "file_type",       :limit => 40
    t.boolean  "activo"
    t.integer  "tramite_id"
    t.integer  "participante_id"
    t.integer  "user_id"
    t.string   "md5",             :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clave_mensaje",   :limit => 6
  end

  add_index "adjuntos", ["activo", "participante_id"], :name => "adjuntos_activo_participante"
  add_index "adjuntos", ["activo", "tramite_id"], :name => "adjuntos_activo_tramite"
  add_index "adjuntos", ["activo", "user_id"], :name => "adjuntos_user"
  add_index "adjuntos", ["clave_mensaje"], :name => "adjuntos_clave_mensaje"

  create_table "adscripcions", :force => true do |t|
    t.string "clave",       :limit => 6
    t.string "descripcion", :limit => 120
  end

  add_index "adscripcions", ["clave"], :name => "index_adscripcions_on_clave", :unique => true

  create_table "amparos", :force => true do |t|
    t.integer  "tramite_id"
    t.date     "fecha"
    t.integer  "tipo_amparo_id"
    t.string   "descripcion",           :limit => 100
    t.string   "observaciones",         :limit => 120
    t.integer  "user_id"
    t.string   "num_amparo",            :limit => 40
    t.integer  "sentido_resolucion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amparos", ["fecha"], :name => "amparos_fecha"
  add_index "amparos", ["num_amparo"], :name => "amparos_numamparo"
  add_index "amparos", ["tramite_id"], :name => "amparos_tramite"

  create_table "atencions", :force => true do |t|
    t.integer  "tramite_id"
    t.integer  "user_id"
    t.datetime "inicio"
    t.datetime "fin"
    t.boolean  "activa"
  end

  add_index "atencions", ["tramite_id", "activa"], :name => "atencion_tramite_activa"

  create_table "audiencia_orals", :force => true do |t|
    t.integer  "tramite_id"
    t.date     "fecha"
    t.integer  "hora"
    t.integer  "minutos"
    t.integer  "tipo_audiencia_id"
    t.integer  "organo_id"
    t.integer  "juez_id"
    t.integer  "defensor_id"
    t.string   "sala",                  :limit => 20
    t.string   "sentencia_dictada"
    t.string   "observaciones",         :limit => 240
    t.boolean  "cancel"
    t.integer  "cancel_user"
    t.string   "motivo_cancelacion"
    t.string   "motivo_reprogramacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audiencia_orals", ["cancel"], :name => "audiencias_orales_cancel"
  add_index "audiencia_orals", ["fecha", "hora", "minutos", "organo_id"], :name => "audiencias_orales_fecha_hora_minutos_organo"
  add_index "audiencia_orals", ["juez_id"], :name => "audiencias_orales_juez"
  add_index "audiencia_orals", ["organo_id"], :name => "audiencias_orales_organo"
  add_index "audiencia_orals", ["tramite_id"], :name => "audiencias_orales_tramite"

  create_table "audiencias", :force => true do |t|
    t.integer  "cve_aud"
    t.datetime "fechahora_atencion"
    t.date     "fecha"
    t.integer  "turno"
    t.integer  "defensor_id"
    t.integer  "estado_audiencia_id"
    t.integer  "tipo_juicio_id"
    t.string   "asunto",              :limit => 500
    t.string   "observaciones",       :limit => 300
    t.string   "procedencia",         :limit => 140
    t.string   "persona_id",          :limit => 36
    t.integer  "adscripcion_id"
    t.boolean  "activo"
    t.boolean  "atendido"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "materia_id"
  end

  add_index "audiencias", ["adscripcion_id", "fecha"], :name => "audiencias_adscripcion_fecha"
  add_index "audiencias", ["cve_aud"], :name => "audiencias_cve_aud"
  add_index "audiencias", ["defensor_id", "fecha", "atendido", "activo"], :name => "audiencias_monitor"
  add_index "audiencias", ["defensor_id"], :name => "audiencias_defensor"
  add_index "audiencias", ["materia_id"], :name => "audiencias_materia"
  add_index "audiencias", ["persona_id"], :name => "audiencias_persona"
  add_index "audiencias", ["turno"], :name => "audiencias_turno"
  add_index "audiencias", ["user_id"], :name => "audiencias_usuario"

  create_table "ausencias", :force => true do |t|
    t.string   "persona_id",         :limit => 36
    t.integer  "motivo_ausencia_id"
    t.datetime "inicio"
    t.datetime "fin"
    t.string   "observaciones",      :limit => 140
    t.boolean  "activo"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ausencias", ["persona_id", "inicio", "fin"], :name => "ausencias_persona_inicio_fin"
  add_index "ausencias", ["persona_id", "motivo_ausencia_id"], :name => "ausencias_persona_motivo"
  add_index "ausencias", ["persona_id"], :name => "ausencias_persona"

  create_table "bitacoras", :force => true do |t|
    t.integer  "tramite_id"
    t.integer  "estatu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bitacoras", ["tramite_id"], :name => "bitacora_tramite"

  create_table "calidads", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "clave_electors", :force => true do |t|
    t.string   "persona_id",  :limit => 36
    t.string   "descripcion", :limit => 18
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clave_electors", ["persona_id"], :name => "persona_clave_elector"

  create_table "concluidos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tramite_id"
    t.integer  "motivo_conclusion_id"
    t.string   "observaciones_conclusion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "concluidos", ["tramite_id"], :name => "concluidos_tramite"
  add_index "concluidos", ["user_id"], :name => "concluidos_user"

  create_table "contactos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contestacions", :force => true do |t|
    t.string   "clave",       :limit => 5
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporacion_policiacas", :force => true do |t|
    t.integer "tipo_corporacion_policiaca_id"
    t.string  "clave",                         :limit => 4
    t.string  "descripcion",                   :limit => 80
    t.string  "direccion",                     :limit => 130
    t.string  "telefonos",                     :limit => 60
  end

  add_index "corporacion_policiacas", ["clave"], :name => "corporacion_policiaca_clave"
  add_index "corporacion_policiacas", ["tipo_corporacion_policiaca_id"], :name => "corporacion_tipo_corporacion_policiaca"

  create_table "defensors", :force => true do |t|
    t.string   "persona_id",   :limit => 36
    t.integer  "municipio_id"
    t.integer  "materia_id"
    t.integer  "cve_def"
    t.boolean  "activo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "defensors", ["materia_id"], :name => "defensor_materia_id"
  add_index "defensors", ["municipio_id"], :name => "defensor_municipio"
  add_index "defensors", ["persona_id"], :name => "defensor_persona", :unique => true

  create_table "domicilios", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entornos", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "estatus", :force => true do |t|
    t.string   "clave",       :limit => 6
    t.string   "descripcion", :limit => 80
    t.boolean  "concluido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extension_personas", :force => true do |t|
    t.string   "persona_id", :limit => 36
    t.integer  "sexo_id"
    t.integer  "idioma_id"
    t.integer  "origen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extension_personas", ["persona_id"], :name => "extension_personas_persona"

  create_table "familiars", :force => true do |t|
    t.string   "persona_id"
    t.string   "nombre",           :limit => 60
    t.string   "apellidos",        :limit => 80
    t.boolean  "vive"
    t.integer  "tipo_familiar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "familiars", ["persona_id", "tipo_familiar_id"], :name => "familiars_persona_tipo_familiar"

  create_table "fiscalias", :force => true do |t|
    t.string  "clave",       :limit => 10
    t.string  "descripcion", :limit => 100
    t.boolean "activa"
  end

  add_index "fiscalias", ["activa"], :name => "fiscalias_activa"
  add_index "fiscalias", ["clave"], :name => "fiscalias_clave", :unique => true

  create_table "guardias", :force => true do |t|
    t.string   "persona_id",    :limit => 36
    t.datetime "inicio"
    t.datetime "fin"
    t.string   "observaciones", :limit => 140
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guardias", ["inicio", "fin"], :name => "guardias_inicio_fin"
  add_index "guardias", ["persona_id", "inicio", "fin"], :name => "guardias_persona_inicio_fin"
  add_index "guardias", ["persona_id"], :name => "guardias_persona"

  create_table "jueces", :force => true do |t|
    t.string   "persona_id",    :limit => 36
    t.integer  "organo_id"
    t.string   "observaciones"
    t.boolean  "activo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jueces", ["organo_id", "activo"], :name => "juez_organo_activo"
  add_index "jueces", ["persona_id"], :name => "juez_persona", :unique => true

  create_table "marginacions", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "materias", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "mecanismo_alternativos", :force => true do |t|
    t.integer  "tramite_id"
    t.date     "fecha"
    t.string   "lugar"
    t.string   "especialista"
    t.integer  "tipo_mecanismo_id"
    t.string   "descripcion_resultado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mensajes", :force => true do |t|
    t.string   "clave",       :limit => 6
    t.integer  "envia_id"
    t.integer  "recibe_id"
    t.string   "asunto",      :limit => 120
    t.string   "descripcion"
    t.integer  "activo"
    t.datetime "leido_at"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mensajes", ["clave"], :name => "mensajes_clave"
  add_index "mensajes", ["envia_id", "owner_id"], :name => "mensajes_usuario_envio"
  add_index "mensajes", ["recibe_id", "owner_id"], :name => "mensajes_usuario_recibido"

  create_table "modificacion_detalles", :force => true do |t|
    t.integer "modificacion_id",               :comment => "Identificador de modificación"
    t.string  "campo",           :limit => 60, :comment => "Columna modificada"
    t.string  "old_value",                     :comment => "valor anterior"
    t.string  "value",                         :comment => "Valor nuevo"
    t.string  "tipo",                          :comment => "Clase del comentario"
  end

  add_index "modificacion_detalles", ["modificacion_id"], :name => "modificacion_detalles_id"

  create_table "modificacions", :force => true do |t|
    t.integer  "id_objeto"
    t.string   "clase",      :limit => 30
    t.integer  "user_id"
    t.boolean  "is_created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modificacions", ["id_objeto", "clase", "is_created"], :name => "modificacions_primer_registro"
  add_index "modificacions", ["user_id"], :name => "modificacions_user"

  create_table "motivo_ausencias", :force => true do |t|
    t.string "clave",       :limit => 4
    t.string "descripcion", :limit => 40
  end

  create_table "motivo_conclusions", :force => true do |t|
    t.string "clave",       :limit => 6
    t.string "descripcion", :limit => 85
  end

  add_index "motivo_conclusions", ["clave"], :name => "motivo_conclusions_clave"

  create_table "organos", :primary_key => "id_organo", :force => true do |t|
    t.integer "fk_tipo_indice",                  :null => false
    t.integer "fk_distrito"
    t.integer "fk_municipio"
    t.integer "numero"
    t.string  "descripcion",      :limit => 100
    t.string  "fk_ramo",          :limit => 1,   :null => false
    t.string  "fk_ponencia",      :limit => 1
    t.string  "tipo_organo",      :limit => 1
    t.integer "estatus_registro"
  end

  add_index "organos", ["fk_distrito"], :name => "Refmunicipios3"
  add_index "organos", ["fk_ramo"], :name => "Reframos27"

  create_table "origens", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "papels", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "participantes", :force => true do |t|
    t.integer  "tramite_id"
    t.string   "persona_id",                           :limit => 36
    t.integer  "tipo_participante_id"
    t.integer  "entorno_id"
    t.integer  "marginacion_id"
    t.integer  "calidad_id"
    t.string   "calificacion_control_detencion"
    t.boolean  "privado_libertad"
    t.boolean  "libre_atraves_medida_cautelar"
    t.boolean  "libre_suspension_condicional_proceso"
    t.datetime "fechahora_detencion"
    t.datetime "fechahora_puesta_a_disposicion"
    t.datetime "fechahora_libertad"
    t.string   "observaciones"
    t.string   "institucion_laboral"
    t.integer  "estado_civil_id"
    t.integer  "cedula_profesional"
    t.integer  "numero_credencial"
    t.string   "especialidad"
    t.integer  "escolaridad_id"
    t.string   "ocupacion"
    t.boolean  "tiene_antecedentes_penales"
    t.string   "antecedentes_penales_delito"
    t.integer  "num_hijos"
    t.boolean  "tiene_padecimiento"
    t.string   "padecimiento_detalle"
    t.integer  "corporacion_policiaca_id"
    t.string   "experiencia_nsjp",                     :limit => 20
    t.string   "experiencia_puesto",                   :limit => 20
    t.integer  "municipio_laboral"
    t.integer  "lengua_materna_id"
    t.string   "cursos",                               :limit => 200
    t.boolean  "requiere_traductor"
    t.boolean  "detenido_flagrancia"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participantes", ["persona_id", "calidad_id"], :name => "participantes_persona_calidad"
  add_index "participantes", ["persona_id", "tipo_participante_id"], :name => "participantes_persona_tipo_participante"
  add_index "participantes", ["persona_id"], :name => "participantes_persona"
  add_index "participantes", ["tramite_id"], :name => "participantes_tramite"

  create_table "participantes_tramites", :id => false, :force => true do |t|
    t.integer "participante_id"
    t.integer "tramite_id"
  end

  add_index "participantes_tramites", ["participante_id"], :name => "index_participantes_tramites_on_participante_id"
  add_index "participantes_tramites", ["tramite_id"], :name => "index_participantes_tramites_on_tramite_id"

  create_table "personas", :primary_key => "id_persona", :force => true, :comment => "personas que realizan tramite en la institucion" do |t|
    t.string   "per_paterno",             :limit => 100, :comment => "apellido paterno"
    t.string   "per_materno",             :limit => 100, :comment => "apellido materno"
    t.string   "per_nombre",              :limit => 100, :comment => "nombre o razon social"
    t.string   "per_rfc",                 :limit => 13,  :comment => "registro federal de contribuyentes"
    t.string   "per_curp",                :limit => 18,  :comment => "clave unica del registro de poblacion"
    t.string   "per_tipo",                :limit => 0,   :comment => "tipo de persona ya sea fisica o moral"
    t.datetime "per_elaboracion",                        :comment => "fecha de elaboracion del registro"
    t.datetime "per_modificacion",                       :comment => "fecha de modificacion del registro"
    t.boolean  "per_activo_reg",                         :comment => "estado de la persona"
    t.string   "fk_usuario_alta",         :limit => 36,  :comment => "alta del usuario"
    t.string   "fk_usuario_modificacion", :limit => 36,  :comment => "modificacion del usuario"
    t.integer  "per_nacionalidad"
    t.date     "per_nacimiento"
  end

  add_index "personas", ["per_curp"], :name => "personas_per_curp"

  create_table "promocions", :force => true do |t|
    t.integer  "tramite_id"
    t.date     "fecha"
    t.string   "titulo",            :limit => 120
    t.string   "descripcion"
    t.integer  "tipo_promocion_id"
    t.integer  "contestacion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promocions", ["tramite_id"], :name => "promocions_tramite"

  create_table "recursos", :force => true do |t|
    t.integer  "tramite_id"
    t.integer  "tipo_recurso_id"
    t.date     "fecha"
    t.string   "descripcion",     :limit => 100
    t.boolean  "admitido"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relacions", :force => true do |t|
    t.integer  "participante_id"
    t.integer  "segundo_participante_id"
    t.integer  "parentesco_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relacions", ["participante_id", "segundo_participante_id"], :name => "relacion_parentesco"

  create_table "roles", :force => true do |t|
    t.string  "name",        :limit => 24
    t.string  "descripcion", :limit => 80
    t.integer "prioridad"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sentencias", :force => true do |t|
    t.string   "clave",                   :limit => 5
    t.integer  "tramite_id"
    t.boolean  "procedimiento_abreviado"
    t.integer  "tipo_sentencia_id"
    t.date     "fecha"
    t.string   "beneficios"
    t.integer  "organo_id"
    t.integer  "instancia_id"
    t.string   "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sentencias", ["tramite_id"], :name => "sentencias_tramite"

  create_table "tipo_amparos", :force => true do |t|
    t.string "clave",       :limit => 4
    t.string "descripcion", :limit => 40
  end

  create_table "tipo_audiencias", :force => true do |t|
    t.string "descripcion", :limit => 120
    t.string "etapa",       :limit => 60
  end

  create_table "tipo_corporacion_policiacas", :force => true do |t|
    t.string "descripcion", :limit => 30
  end

  create_table "tipo_familiars", :force => true do |t|
    t.string   "clave",       :limit => 5
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_juicios", :force => true do |t|
    t.integer "materia_id"
    t.string  "descripcion"
  end

  create_table "tipo_mecanismos", :force => true do |t|
    t.string   "clave",       :limit => 4
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_participantes", :force => true do |t|
    t.string "clave",       :limit => 4
    t.string "descripcion", :limit => 60
  end

  add_index "tipo_participantes", ["clave"], :name => "tipo_participantes_clave"

  create_table "tipo_promocions", :force => true do |t|
    t.string   "clave",       :limit => 4
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_recursos", :force => true do |t|
    t.string   "clave",       :limit => 4
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_sentencias", :force => true do |t|
    t.string   "clave",       :limit => 4
    t.string   "descripcion", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tramites", :force => true do |t|
    t.string   "anio",                  :limit => 4
    t.string   "folio_expediente",      :limit => 5
    t.string   "nuc",                   :limit => 18
    t.string   "registro_atencion",     :limit => 40
    t.string   "carpeta_investigacion", :limit => 40
    t.string   "causa_penal",           :limit => 60
    t.datetime "fechahora_atencion"
    t.integer  "fiscalia_id"
    t.string   "calificacion_juridica", :limit => 60
    t.integer  "defensor_id"
    t.integer  "materia_id"
    t.integer  "delito_norma_id"
    t.string   "observaciones"
    t.string   "hecho_delictivo",       :limit => 140
    t.boolean  "es_delito_grave"
    t.boolean  "concluido"
    t.boolean  "es_urgente"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estatu_id"
  end

  add_index "tramites", ["anio"], :name => "tramites_anio"
  add_index "tramites", ["carpeta_investigacion"], :name => "tramites_carpeta_investigacion"
  add_index "tramites", ["causa_penal"], :name => "tramites_causa_penal"
  add_index "tramites", ["concluido"], :name => "tramites_concluido"
  add_index "tramites", ["defensor_id", "fechahora_atencion"], :name => "tramites_defensor_fechahora_atencion"
  add_index "tramites", ["defensor_id"], :name => "tramites_defensor"
  add_index "tramites", ["estatu_id"], :name => "tramite_estatu"
  add_index "tramites", ["nuc"], :name => "tramites_nuc"

  create_table "users", :force => true do |t|
    t.string   "persona_id",                :limit => 36
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "last_login"
    t.string   "last_ip",                   :limit => 15
    t.integer  "adscripcion_id"
    t.boolean  "activo"
  end

  add_index "users", ["adscripcion_id"], :name => "user_adscripcion"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persona_id", "activo"], :name => "user_persona_activo"
  add_index "users", ["persona_id"], :name => "user_persona", :unique => true

end
