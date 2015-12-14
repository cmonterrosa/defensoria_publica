class CreateTipoParticipantes < ActiveRecord::Migration
  def self.up
    create_table :tipo_participantes do |t|
      t.column :clave, :string, :limit => 4
      t.column :descripcion, :string, :limit => "60"
    end

    TipoParticipante.create(:clave => "MINP", :descripcion => "Ministerio público") unless TipoParticipante.exists?(:clave => "MINP")
    TipoParticipante.create(:clave => "DEFE", :descripcion => "Defensor") unless TipoParticipante.exists?(:clave => "DEFE")
    TipoParticipante.create(:clave => "PERI", :descripcion => "Perito") unless TipoParticipante.exists?(:clave => "PERI")
    TipoParticipante.create(:clave => "POLI", :descripcion => "Policia") unless TipoParticipante.exists?(:clave => "POLI")
    TipoParticipante.create(:clave => "DEFI", :descripcion => "Defensor investigador") unless TipoParticipante.exists?(:clave => "DEFI")
    TipoParticipante.create(:clave => "TEST", :descripcion => "Testigo") unless TipoParticipante.exists?(:clave => "TEST")
    TipoParticipante.create(:clave => "VICT", :descripcion => "Víctima") unless TipoParticipante.exists?(:clave => "VICT")
    TipoParticipante.create(:clave => "ACU", :descripcion => "Acusado") unless TipoParticipante.exists?(:clave => "ACU")

    add_index :tipo_participantes, :clave, :name => "tipo_participantes_clave"
  end

  def self.down
    drop_table :tipo_participantes
  end
end
