######################################
# == Modelo "tramite"
# sirve como columna vertebral del proyecto
# y conecta con múltiples modelos que giran alrededor,
# automaticamente almacena modificaciones en bitacora
# y genera folio
######################################

class Tramite < ActiveRecord::Base
  has_many :participantes
  has_many :partes
  has_many :amparos
  has_many :promocions
  has_many :audiencia_orals
  has_many :recursos
  has_many :sentencias
  has_many :modificacions, :foreign_key =>"id_objeto"
  has_many :adjuntos, :conditions => "activo = true"
  has_many :atencions
  has_many :mecanismo_alternativos
  belongs_to :defensor
  belongs_to :fiscalia
  belongs_to :estatu
  belongs_to :materia
  belongs_to :organo
  belongs_to :tipo_juicio
   

  named_scope :penal, :conditions => {:materia_id => Materia.find_by_descripcion("PENAL").id}
  named_scope :nopenal, :conditions => ['materia_id  != ?', Materia.find_by_descripcion("PENAL").id]

  attr_reader :current_journal
  
  #validates_uniqueness_of :nuc

  #before_save :generar_folio
  
  after_save :crear_modificaciones

  # Buscador
   def self.search(search, user=nil)
     user_condition = (user) ? "solicitante_id = #{user.id} AND " : ''
     (search) ? find(:all, :conditions => ["#{user_condition} carpeta_investigacion LIKE ? OR nuc LIKE ? OR registro_atencion LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%"], :order => "created_at DESC") :  find(:all)
   end

   # Devuelve el usuario soliciante
   def solicitante
    (self.solicitante_id)? User.find(self.solicitante_id) : nil
   end

   def es_penal?
     (self.materia && self.materia ==  Materia.find_by_descripcion("PENAL"))
   end

   # Devuelve el objeto de delito del catalogo
   def delito_norma
     (self.delito_norma_id)? DelitoNorma.find(self.delito_norma_id) : nil
   end

   # Regresa el primer objeto del modelo concluido perteneciente al tramite
   def concluido
     Concluido.find(:first, :conditions => ["tramite_id = ?", self.id], :order => "updated_at") if self.id
   end

   # Regresa el valor true o false dependiendo si el trámite ya fue concluido
   def concluido?
     Concluido.count(:id, :conditions => ["tramite_id = ?", self.id], :order => "updated_at") > 0 if self.id
   end

   
   def verificar_registro_atencion(user)
       if user && self.id
         @anteriores = Atencion.find(:all, :conditions => ["tramite_id = ? AND user_id != ?", self.id, user.id])
         @actual = Atencion.find(:first, :conditions => ["user_id = ? AND tramite_id = ?", user.id, self.id])
         @actual ||= Atencion.new(:user_id => user.id, :tramite_id => self.id)
         @actual.inicio ||= Time.now
         @actual.activa ||= true
         if @actual.save
            @anteriores.each do |a|
                a.fin ||= Time.now
                a.activa = false
                a.save
            end
         end
      end
    end

   # Función que genera busca el último folio del año y asigna el consecutivo
   def generar_folio
     self.anio ||= Time.now.year
     unless self.folio_expediente
        maximo=  Tramite.maximum(:folio_expediente, :conditions => ["anio = ?", self.anio])
        folio_expediente = 1 unless maximo
        folio_expediente ||= maximo.to_i + 1
        self.folio_expediente = folio_expediente
     end
   end

   # Forma dinámicamente el número de trámite con base en año y folio
   def numero_tramite
    "#{self.anio[2..4]}#{self.folio_expediente.to_s.rjust(5, '0')}" if self.anio && self.folio_expediente
   end

   # Forma el identificador unico de tramite
   def identificador_unico
     organo = (self.organo_id)? self.organo_id.to_s.rjust(2, "0") : "00"
      organo + self.created_at.year.to_s + self.id.to_s.rjust(5, '0') 
   end

   # Método que verifica si cuenta con un número de expediente válido
   #def has_numero_expediente?
      #self.anio && self.folio_expediente
   #end

    # Muestra un string con información del trámite
    def show_info
      "REGISTRO DE ATENCION: #{self.registro_atencion}" + " |  CAUSA PENAL: #{self.causa_penal} |  CARPETA DE INVESTIGACIÓN: #{self.carpeta_investigacion}  |  NUC: #{self.nuc}"
    end

    # Muestra el número de expediente
    #def numero_expediente
     #(self.folio_expediente) ?  "#{self.folio_expediente.to_s.rjust(4, '0')}/#{self.anio}" : nil
    #end

   # Inicia el registro de modificación
   def init_journal(user)
      @current_journal ||= Modificacion.new(:id_objeto => self.id, :user_id => user.id, :clase => self.class.to_s) if user
      @issue_before_change = self.clone
      @current_journal
    end

   # Guarda cambios en bitacora y es llamado despues de guardar un objeto
   def crear_modificaciones
      if @current_journal
        @current_journal.id_objeto ||= self.id
        @current_journal.is_created = (Modificacion.exists?(['clase = ? AND id_objeto = ? AND is_created = ?', @current_journal.clase, @current_journal.id_objeto, true ])) ? false : true
        # attributes changes
        (Tramite.column_names - %w(id updated_at created_at)).each {|c|
          before = @issue_before_change.send(c)
          after = send(c)
          next if before == after || (before.blank? && after.blank?)
          @current_journal.modificacion_detalles << ModificacionDetalle.new(
                                                        :tipo => c.class.to_s,
                                                        :campo => c,
                                                        :old_value => @issue_before_change.send(c),
                                                        :value =>  send(c))
          }
        begin
            if @current_journal.save
              # reset current journal
              init_journal @current_journal.user
            end
        rescue  => err
            puts err
        end
    end
  end

  # Notificar de nuevo tramite
  def notificar_por_email
  # sent a message to users from jefefensor and notificante roles if at least one row is exists
  success=false
  unless self.participantes.empty?
    Role.find_by_name("jefedefensor").active_users.each{ |j|  TramiteMailer.deliver_notification_created(j, self.id) && success=true if j.email_valid? }
    Role.find_by_name("notificante").active_users.each{ |n|  TramiteMailer.deliver_notification_created(n, self.id) && success=true if n.email_valid? }
  end
  return success
 end

  # Regresa un arreglo de los usuarios que recibirán notificacion (Solo materia penal)
  def users_allowed_for_notification
   if self.materia && (self.materia == Materia.find_by_descripcion("PENAL"))
      unless self.participantes.empty?
        array=[]
        Role.find_by_name("jefedefensor").active_users.each{ |i| array << i  if i.email_valid? }
        Role.find_by_name("notificante").active_users.each{ |i| array << i  if i.email_valid? }
      end
   end
   return array
 end

  # Actualización del estatus del trámite y además guarda registro en bitácora
  def update_estatus!(clave,usuario)
    begin
      @estatus = Estatu.find_by_clave(clave) if (!clave.nil? && !usuario.nil?)
      @bitacora = Bitacora.new(:tramite_id => self.id, :estatu_id => @estatus.id, :user_id => usuario.id ) if @estatus
      @tiene_historia = Bitacora.count(:id, :conditions => ["tramite_id = ? AND estatu_id = ?", self.id, @estatus.id])
      success = (self.estatu_id != @estatus.id) && @tiene_historia < 1
      (success && @bitacora.save) ? self.update_attributes!(:estatu_id => @estatus.id) : false
    rescue Exception => exception
        puts exception if usuario
    end
  end

end
