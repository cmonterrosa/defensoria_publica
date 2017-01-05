class CreateTipoJuicios < ActiveRecord::Migration
  def self.up
    create_table :tipo_juicios do |t|
      t.column :materia_id, :integer
      t.column :clave, :string, :limit => 6
      t.column :descripcion, :string, :limit => 80
      end

      TipoJuicio.create(:materia_id=> 3, :clave=>"ACREDI", :descripcion=> "Acreditación de persona")
      TipoJuicio.create(:materia_id=> 3, :clave=>"AUPENS", :descripcion=> "Aumento de pensión")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CMBREG", :descripcion=> "Cambio de régimen")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CESPEN", :descripcion=> "Cesación de pensión")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONCUB", :descripcion=> "Concubinato")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTAL", :descripcion=> "Contestación aumento de alimentos")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTCE", :descripcion=> "Contestación de cesación")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTVI", :descripcion=> "Contestación de derecho de visita")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTDP", :descripcion=> "Contestación de desconocimiento de paternidad")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTDN", :descripcion=> "Contestación de divorcio necesario")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTGY", :descripcion=> "Contestación de guardia y custodia")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTRP", :descripcion=> "Contestación de reconocimiento de paternidad")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTRM", :descripcion=> "Contestación de recuperación de menor")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTRA", :descripcion=> "Contestación de reducción de alimentos")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONTDA", :descripcion=> "Contestación demanda alimentos")
      TipoJuicio.create(:materia_id=> 3, :clave=>"CONVEN", :descripcion=> "Convenio")
      TipoJuicio.create(:materia_id=> 3, :clave=>"ALIMEN", :descripcion=> "Demanda de alimentos")
      TipoJuicio.create(:materia_id=> 3, :clave=>"DEPECO", :descripcion=> "Dependencia económica")
      TipoJuicio.create(:materia_id=> 3, :clave=>"DERVIS", :descripcion=> "Derecho de visita")
      TipoJuicio.create(:materia_id=> 3, :clave=>"DIVNEC", :descripcion=> "Divorcio necesario")
      TipoJuicio.create(:materia_id=> 3, :clave=>"DIVVOL", :descripcion=> "Divorcio voluntario")
      TipoJuicio.create(:materia_id=> 3, :clave=>"INTERD", :descripcion=> "Estado de interdicción")
      TipoJuicio.create(:materia_id=> 3, :clave=>"GUCUST", :descripcion=> "Guarda y custodia")
      TipoJuicio.create(:materia_id=> 3, :clave=>"NMBTUT", :descripcion=> "Nombramiento de tutor")
      TipoJuicio.create(:materia_id=> 3, :clave=>"RECPAT", :descripcion=> "Reconocimiento de paternidad")
      TipoJuicio.create(:materia_id=> 3, :clave=>"RECTPA", :descripcion=> "Rectificación de acta de defunción")
      TipoJuicio.create(:materia_id=> 3, :clave=>"RECTMA", :descripcion=> "Rectificación de acta de matrimonio")
      TipoJuicio.create(:materia_id=> 3, :clave=>"RECTNA", :descripcion=> "Rectifiación de acta de nacimiento")
      TipoJuicio.create(:materia_id=> 3, :clave=>"RECMEN", :descripcion=> "Recuperación de menor")
      TipoJuicio.create(:materia_id=> 3, :clave=>"REDPEN", :descripcion=> "Reducción de pensión")

  end

  def self.down
    drop_table :tipo_juicios
  end
end
