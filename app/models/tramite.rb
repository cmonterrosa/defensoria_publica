######################################
# Modelo "tramite", sirve como columna vertebral
# y conecta con múltiples modelos que giran alrededor,
# automaticamente almacena modificaciones en bitacora
# y genera folio
######################################

class Tramite < ActiveRecord::Base
  has_many :participantes
  has_many :amparos
  has_many :promocions
  has_many :audiencia_orals
  has_many :recursos
  has_many :sentencias
  has_many :modificacions, :foreign_key =>"id_objeto"
  has_many :adjuntos, :conditions => "activo = true"
  has_many :atencions
  belongs_to :defensor
  belongs_to :fiscalia
  belongs_to :estatu

  attr_reader :current_journal
  
  #validates_uniqueness_of :nuc

  before_save :generar_folio
  
  after_save :crear_modificaciones

   def self.search(search, user=nil)
     user_condition = (user) ? "solicitante_id = #{user.id} AND " : ''
     (search) ? find(:all, :conditions => ["#{user_condition} carpeta_investigacion LIKE ? OR nuc LIKE ? OR registro_atencion LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%"], :order => "created_at DESC") :  find(:all)
   end

   def solicitante
    (self.solicitante_id)? User.find(self.solicitante_id) : nil
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

   def generar_folio
     self.anio ||= Time.now.year
     unless self.folio_expediente
        maximo=  Tramite.maximum(:folio_expediente, :conditions => ["anio = ?", self.anio])
        folio_expediente = 1 unless maximo
        folio_expediente ||= maximo.to_i + 1
        self.folio_expediente = folio_expediente
     end
   end

   def numero_tramite
    "#{self.anio[2..4]}#{self.folio_expediente.to_s.rjust(5, '0')}" if self.anio && self.folio_expediente
   end

    def show_info
      "REGISTRO DE ATENCION: #{self.registro_atencion}" + " |  CAUSA PENAL: #{self.causa_penal} |  CARPETA DE INVESTIGACIÓN: #{self.carpeta_investigacion}  |  NUC: #{self.nuc}"
    end

  def init_journal(user)
    @current_journal ||= Modificacion.new(:id_objeto => self.id, :user_id => user.id, :clase => self.class.to_s) if user
    @issue_before_change = self.clone
    @current_journal
  end


  # Guarda cambios en bitacora
  # Llamado despues de guadar
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



end
