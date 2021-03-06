class CreateTipoParticipantes < ActiveRecord::Migration
  def self.up
    create_table :tipo_participantes do |t|
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => "60"
    end

    TipoParticipante.create(:clave => "ASEJ", :descripcion => "Asesor Jurídico") unless TipoParticipante.exists?(:clave => "ASEJ")
    TipoParticipante.create(:clave => "MPTU", :descripcion => "Ministerio público de turno") unless TipoParticipante.exists?(:clave => "MPTU")
    TipoParticipante.create(:clave => "MPTR", :descripcion => "Ministerio público de trámite") unless TipoParticipante.exists?(:clave => "MPTR")
    TipoParticipante.create(:clave => "PERO", :descripcion => "Perito Oficial") unless TipoParticipante.exists?(:clave => "PERO")
    TipoParticipante.create(:clave => "PERP", :descripcion => "Perito Privado") unless TipoParticipante.exists?(:clave => "PERP")
    TipoParticipante.create(:clave => "POLI", :descripcion => "Policia") unless TipoParticipante.exists?(:clave => "POLI")
    TipoParticipante.create(:clave => "TEST", :descripcion => "Testigo") unless TipoParticipante.exists?(:clave => "TEST")
    TipoParticipante.create(:clave => "VICT", :descripcion => "Víctima") unless TipoParticipante.exists?(:clave => "VICT")
    TipoParticipante.create(:clave => "ACU", :descripcion => "Imputado") unless TipoParticipante.exists?(:clave => "ACU")

    add_index :tipo_participantes, :clave, :name => "tipo_participantes_clave"
  end

  def self.down
    drop_table :tipo_participantes
  end
end
