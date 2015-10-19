class CreatePersonas < ActiveRecord::Migration
  def self.up
    ### Tabla con estructura igual a la que ocupa personas ###
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS personas;")
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS pr_persona;")
    ActiveRecord::Base.connection.execute <<EOS
      CREATE TABLE `personas` (
  `id_persona` char(36) COLLATE utf8_spanish2_ci NOT NULL COMMENT 'identificador unico de la persona',
  `per_paterno` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'apellido paterno',
  `per_materno` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'apellido materno',
  `per_nombre` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'nombre o razon social',
  `per_rfc` varchar(13) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'registro federal de contribuyentes',
  `per_curp` varchar(18) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'clave unica del registro de poblacion',
  `per_tipo` enum('FISICA','MORAL') COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'tipo de persona ya sea fisica o moral',
  `per_elaboracion` datetime DEFAULT NULL COMMENT 'fecha de elaboracion del registro',
  `per_modificacion` datetime DEFAULT NULL COMMENT 'fecha de modificacion del registro',
  `per_activo_reg` tinyint(1) DEFAULT NULL COMMENT 'estado de la persona',
  `fk_usuario_alta` char(36) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'alta del usuario',
  `fk_usuario_modificacion` char(36) COLLATE utf8_spanish2_ci DEFAULT NULL COMMENT 'modificacion del usuario',
  `per_nacionalidad` int(11) DEFAULT NULL,
  `per_nacimiento` date DEFAULT NULL,
  PRIMARY KEY (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci COMMENT='personas que realizan tramite en la institucion';

EOS

add_index :personas, :per_curp, :name => "personas_per_curp"

end

  def self.down
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'personas';")
  end
end

