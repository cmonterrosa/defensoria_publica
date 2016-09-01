# Permite crear mensajes entre usuarios del sistema
class Mensaje < ActiveRecord::Base

  before_save :generate_key
  after_create :create_dup
  validates_uniqueness_of :clave, :scope => :owner_id,  :message => "ya se encuentra registrado"
 

  def adjuntos
    mensajes_relacionados = Mensaje.find(:all, :conditions => ["clave = ?", self.clave])
    return Adjunto.find(:all)
  end


  # Devuelve objeto del usuario que es destinatario del mensaje
  def destinatario
    user = User.find(self.recibe_id) if self.recibe_id
    destinatario ||= user.persona.nombre_completo if user && user.persona
    return destinatario
  end
 
  # Devuelve objeto del usuario que envia mensaje
  def remitente
    user = User.find(self.envia_id) if self.envia_id
    remitente ||= user.persona.nombre_completo if user && user.persona.nombre_completo
    return remitente
   end

  def generate_key
    self.clave ||=  (0...6).map { ('a'..'z').to_a[rand(26)] }.join
  end

  # Establece que un mensaje ha sido leido en ambos objetos
  def set_readed!(date=DateTime.now)
    mensajes = Mensaje.find(:all, :conditions => ["clave = ?", self.clave])
      mensajes.each do |m|
        m.update_attributes!(:leido_at => date)
      end
  end

  # crea registro duplicado para el remitente y destinatario
   def create_dup
     self.generate_key
     new = Mensaje.new(self.attributes.merge(:owner_id =>self.recibe_id))
     self.owner_id  ||= self.envia_id
     self.save
     new.owner_id  = self.recibe_id
     new.save if (new.valid? && !Mensaje.exists?(:clave => self.clave, :owner_id => new.owner_id))
   end

end
