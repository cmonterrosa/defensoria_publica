class Ausencia < ActiveRecord::Base
  belongs_to :persona
  belongs_to :motivo_ausencia


   def self.search(search)
    if search
      find(:all, :joins => "a, personas p", :select => "a.* ", :conditions => ['BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"], :order => "a.inicio, a.fin DESC")
    else
      find(:all)
    end
  end

end
