class CreateMotivoAusencias < ActiveRecord::Migration
  def self.up
    create_table :motivo_ausencias do |t|
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => 40
    end
    
    MotivoAusencia.create(:clave => "AUDI", :descripcion => "Audiencia")
    MotivoAusencia.create(:clave => "VIJU", :descripcion => "Visita a Juzgado")
    MotivoAusencia.create(:clave => "PERM", :descripcion => "Permiso")
    MotivoAusencia.create(:clave => "INCA", :descripcion => "Incapacidad")
    MotivoAusencia.create(:clave => "CONM", :descripcion => "Consulta médica")
    MotivoAusencia.create(:clave => "LICE", :descripcion => "Licencia")
    MotivoAusencia.create(:clave => "AEPJ", :descripcion => "Actividad extraordinaria dentro del PJ")
    MotivoAusencia.create(:clave => "MOPE", :descripcion => "Motivo personal")
    MotivoAusencia.create(:clave => "OTRO", :descripcion => "Otro motivo")
end

  def self.down
    drop_table :motivo_ausencias
  end
end
