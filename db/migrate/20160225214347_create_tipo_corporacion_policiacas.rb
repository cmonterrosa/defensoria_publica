class CreateTipoCorporacionPoliciacas < ActiveRecord::Migration
  def self.up
    create_table :tipo_corporacion_policiacas do |t|
      t.column :descripcion, :string, :limit => 30
    end

    @f = TipoCorporacionPoliciaca.create(:descripcion => "FEDERAL") unless TipoCorporacionPoliciaca.exists?(:descripcion => "FEDERAL")
    @e = TipoCorporacionPoliciaca.create(:descripcion => "ESTATAL") unless TipoCorporacionPoliciaca.exists?(:descripcion => "ESTATAL")
    @m = TipoCorporacionPoliciaca.create(:descripcion => "MUNICIPAL") unless TipoCorporacionPoliciaca.exists?(:descripcion => "MUNICIPAL")
    @p = TipoCorporacionPoliciaca.create(:descripcion => "PRIVADA") unless TipoCorporacionPoliciaca.exists?(:descripcion => "PRIVADA")

    #TipoCorporacionPoliciaca.reset_column_information
    CorporacionPoliciaca.reset_column_information
    puts("=> Refresca estructura")

    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @m.id, :clave => "PMUN", :descripcion => "POLICIA MUNICIPAL") unless CorporacionPoliciaca.exists?(:clave => "PMUN")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "PEFR", :descripcion => "POLICIA ESTATAL FRONTERIZA") unless CorporacionPoliciaca.exists?(:clave => "PEFR")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "PEPR", :descripcion => "POLICIA ESTATAL PREVENTIVA") unless CorporacionPoliciaca.exists?(:clave => "PEPR")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "PEET", :descripcion => "POLICIA ESTATAL DE TRÁNSITO") unless CorporacionPoliciaca.exists?(:clave => "PEET")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "PETC", :descripcion => "POLICIA ESTATAL DE TURISMO Y CAMINOS") unless CorporacionPoliciaca.exists?(:clave => "PETC")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "SPEN", :descripcion => "SEGURIDAD PENITENCIARIA") unless CorporacionPoliciaca.exists?(:clave => "SPEN")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "FCIU", :descripcion => "FUERZA CIUDADANA") unless CorporacionPoliciaca.exists?(:clave => "FCIU")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "SEGU", :descripcion => "SERVICIOS ESTRATEGICOS DE SEGURIDAD") unless CorporacionPoliciaca.exists?(:clave => "SEGU")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @e.id, :clave => "PEMI", :descripcion => "POLICIA ESTATAL MINISTERIAL") unless CorporacionPoliciaca.exists?(:clave => "PEMI")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @f.id, :clave => "PFED", :descripcion => "POLICIA FEDERAL") unless CorporacionPoliciaca.exists?(:clave => "PETC")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @f.id, :clave => "GNAC", :descripcion => "GENDARMERÍA NACIONAL") unless CorporacionPoliciaca.exists?(:clave => "GNAC")
    CorporacionPoliciaca.create(:tipo_corporacion_policiaca_id => @f.id, :clave => "PFMI", :descripcion => "POLICIA FEDERAL MINISTERIAL") unless CorporacionPoliciaca.exists?(:clave => "PETC")
  end

  def self.down
    drop_table :tipo_corporacion_policiacas
  end
end

