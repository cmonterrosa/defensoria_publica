######################################
# Modelo "tramite", sirve como columna vertebral
# y conecta con múltiples modelos que giran alrededor
######################################

class Tramite < ActiveRecord::Base
  has_and_belongs_to_many :participantes
  has_many :amparos
  has_many :promocions
  has_many :audiencia_orals
  belongs_to :defensor
  belongs_to :fiscalia

  #validates_uniqueness_of :nuc


   def self.search(search, user)
     user_condition = (user) ? "solicitante_id = #{user.id} AND " : ''
    if search
      find(:all, :conditions => ["#{user_condition} carpeta_investigacion LIKE ? OR nuc LIKE ?", "%#{search}%", "%#{search}%"], :order => "created_at DESC")
    else
      find(:all)
    end
   end

   def solicitante
    (self.solicitante_id)? User.find(self.solicitante_id) : nil
   end

end
