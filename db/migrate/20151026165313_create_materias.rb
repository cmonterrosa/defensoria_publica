class CreateMaterias < ActiveRecord::Migration
  def self.up
    create_table :materias do |t|
      t.column :descripcion, :string, :limit => 40
    end

   ### Creamos catalogo de materias ####
   Materia.create(:descripcion => "CIVIL") unless Materia.find_by_descripcion("CIVIL")
   Materia.create(:descripcion => "MERCANTIL") unless Materia.find_by_descripcion("MERCANTIL")
   Materia.create(:descripcion => "FAMILIAR") unless Materia.find_by_descripcion("FAMILIAR")
   Materia.create(:descripcion => "PENAL") unless Materia.find_by_descripcion("PENAL")
   Materia.create(:descripcion => "LABORAL") unless Materia.find_by_descripcion("LABORAL")
   Materia.create(:descripcion => "AGRARIA") unless Materia.find_by_descripcion("AGRARIA")
   Materia.create(:descripcion => "ADMINISTRATIVA") unless Materia.find_by_descripcion("ADMINISTRATIVA")
   Materia.create(:descripcion => "JUSTICIA PARA ADOLESCENTES") unless Materia.find_by_descripcion("JUSTICIA PARA ADOLESCENTES")
   Materia.create(:descripcion => "MIXTA") unless Materia.find_by_descripcion("MIXTA")
   Materia.create(:descripcion => "OTRA") unless Materia.find_by_descripcion("OTRA")

  #### Creamos catalogo de tipo de juicios ####

  familiar = Materia.find_by_descripcion("FAMILIAR")
  adolescentes = Materia.find_by_descripcion("JUSTICIA PARA ADOLESCENTES")
  
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "VIOLENCIA") unless TipoJuicio.find_by_descripcion("VIOLENCIA")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "DIVORCIO COMO CAUSAL DE VIOLENCIA") unless TipoJuicio.find_by_descripcion("DIVORCIO COMO CAUSAL DE VIOLENCIA")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "GUARDIA Y CUSTODIA") unless TipoJuicio.find_by_descripcion("GUARDIA Y CUSTODIA")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "ALIMENTOS") unless TipoJuicio.find_by_descripcion("ALIMENTOS")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "DERECHO DE VISITA") unless TipoJuicio.find_by_descripcion("DERECHO DE VISITA")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "DISPENSA DE EDAD") unless TipoJuicio.find_by_descripcion("DISPENSA DE EDAD")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "JUICIO ESPECIFICO POR SER DISCAPACITADO") unless TipoJuicio.find_by_descripcion("JUICIO ESPECIFICO POR SER DISCAPACITADO")
  TipoJuicio.create(:materia_id => adolescentes.id, :descripcion => "JUICIO ESPECIFICO POR SER MENOR DE EDAD") unless TipoJuicio.find_by_descripcion("JUICIO ESPECIFICO POR SER MENOR DE EDAD")
  TipoJuicio.create(:materia_id => familiar.id, :descripcion => "OTRO") unless TipoJuicio.find_by_descripcion("OTRO")


  end

  def self.down
    drop_table :materias
  end
end
