######################################
# Modelo "tramite", sirve como columna vertebral
# y conecta con múltiples modelos que giran alrededor
######################################

class Tramite < ActiveRecord::Base
  has_and_belongs_to_many :participantes
  belongs_to :defensor

  validates_uniqueness_of :nuc


   def self.search(search)
    if search
      find(:all, :conditions => ['carpeta_investigacion LIKE ? OR nuc LIKE ?', "%#{search}%", "%#{search}%"], :order => "created_at DESC")
    else
      find(:all)
    end
   end

end
