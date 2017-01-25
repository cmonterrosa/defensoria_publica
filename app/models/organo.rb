class Organo < ActiveRecord::Base
  set_primary_key "id_organo"
  has_many :audiencia_orals

  named_scope :juzgados_familiares, :conditions => {:fk_ramo => "F", :tipo_organo => "J"}
  named_scope :salas_familiares, :conditions => {:fk_ramo => "F", :tipo_organo => "S"}
  named_scope :juzgados_civiles, :conditions => {:fk_ramo => "C", :tipo_organo => "J"}
  named_scope :salas_civiles, :conditions => {:fk_ramo => "C", :tipo_organo => "S"}
  named_scope :juzgados_control, :conditions => {:fk_ramo => "", :tipo_organo => "J"}

  def distrito
      Catalogo.distritos.find_by_clave(self.fk_distrito) if self.fk_distrito
  end

end
