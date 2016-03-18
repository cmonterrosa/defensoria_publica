######################################
# Modelo "tramite", sirve como columna vertebral
# y conecta con múltiples modelos que giran alrededor
# automaticamente almacena modificaciones en bitacora
######################################

class Tramite < ActiveRecord::Base
  has_many :participantes
  has_many :amparos
  has_many :promocions
  has_many :audiencia_orals
  has_many :recursos
  has_many :sentencias
  belongs_to :defensor
  belongs_to :fiscalia

  attr_reader :current_journal
  
  #validates_uniqueness_of :nuc
  
  after_save :crear_modificaciones

   def self.search(search, user=nil)
     user_condition = (user) ? "solicitante_id = #{user.id} AND " : ''
     (search) ? find(:all, :conditions => ["#{user_condition} carpeta_investigacion LIKE ? OR nuc LIKE ?", "%#{search}%", "%#{search}%"], :order => "created_at DESC") :  find(:all)
   end

   def solicitante
    (self.solicitante_id)? User.find(self.solicitante_id) : nil
   end


  def init_journal(user)
    @current_journal ||= Modificacion.new(:id_objeto => self.id, :user_id => user.id, :clase => self.class.to_s)
    @issue_before_change = self.clone
    #@issue_before_change.status = self.status
    @current_journal
  end


  # Guarda cambios en bitacora
  # Llamado despues de guadar
  def crear_modificaciones
    if @current_journal
      # attributes changes
      (Tramite.column_names - %w(id updated_at created_at)).each {|c|
        before = @issue_before_change.send(c)
        after = send(c)
        #after = self["#{c}"]
        next if before == after || (before.blank? && after.blank?)
        @current_journal.modificacion_detalles << ModificacionDetalle.new(
                                                      :tipo => c.class.to_s,
                                                      :campo => c,
                                                      :old_value => @issue_before_change.send(c),
                                                      :value =>  send(c))
      }

      begin
        puts("=> Trying to save")
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
