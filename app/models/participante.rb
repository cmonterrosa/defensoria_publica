######################################
# Modelo "participante", posee los datos de cada participante
# de una causa, y esta asociada con un objeto persona
######################################

class Participante < ActiveRecord::Base
 belongs_to :tramite
 belongs_to :persona
 belongs_to :calidad
 belongs_to :entorno
 belongs_to :marginacion
 belongs_to :papel
 belongs_to :tipo_participante
 belongs_to :corporacion_policiaca
 has_many :relacions
 has_many :modificacions, :foreign_key =>"id_objeto"

 validates_presence_of :tramite_id, :message => "- Debe vincularse a un tramite"

 after_save :crear_modificaciones

  #validates_presence_of :persona_id, :message => "- Debe vincularse a una persona"
  

  def self.search(search,tramite)
    if search
      find(:all, :joins => "a, participantes_tramites pt, tramites t, personas p",
        :select => "a.* ",
        :conditions => ['a.id=pt.participante_id AND pt.tramite_id=t.id AND BINARY a.persona_id= BINARY p.id_persona AND  CONCAT(p.per_nombre, \' \' , p.per_paterno, \' \' , p.per_materno) LIKE ?', "%#{search}%"],
        :order => "a.created_at DESC")
    elsif tramite
      find(:all, :joins => "a, participantes_tramites pt, tramites t, personas p",
        :conditions => ['a.id=pt.participante_id AND pt.tramite_id=t.id AND BINARY a.persona_id'],
        :select => "a.* ",  :order => "a.created_at DESC")
    else
        Array.new
    end
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
      (Participante.column_names - %w(id tramite_id updated_at created_at)).each {|c|
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
