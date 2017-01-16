#############################################
# == Modelo que extiende los datos contenidos en modelo de persona
#############################################

class ExtensionPersona < ActiveRecord::Base
  belongs_to :persona
  #belongs_to :sexo, :class_name => 'Catalogo.sexos', :foreign_key => "id_elementos"
  #belongs_to :idioma, :class_name => 'Catalogo.idioma', :foreign_key => "id_elementos"
  #belongs_to :origen

  def sexo
    return Catalogo.sexos(self.sexo_id).first
  end

  def idioma
    return Catalogo.idioma(self.idioma_id).first
  end





end
