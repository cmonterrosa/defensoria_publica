##################################
# Modelo que conecta directamente a tabla de persona
#
##################################

class Persona < ActiveRecord::Base
  include UUIDHelper
  establish_connection "persona"
  set_table_name "pr_persona"
  set_primary_key "id_persona"

#  validates_format_of :per_curp, :with => /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/,
#    :allow_blank => true, :message => "Formato inválido"

  before_save :validates_curp

  def validates_curp
    if self.per_curp && self.per_curp.size == 18
        self.per_curp = '' unless self.per_curp =~ /\A[A-Z][AEIOUX][A-Z]{2}[0-9]{2}[0-1][0-9][0-3][0-9][MH][A-Z][BCDFGHJKLMNÑPQRSTVWXYZ]{4}[0-9A-Z][0-9]\z/
    else
        self.per_curp=''
    end
    return true
  end

  def nombre_completo
     "#{self.per_nombre} #{self.per_paterno} #{self.per_materno}"
  end

  def nombre_curp
    nombre_completo + "| #{self.per_curp}"
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['CONCAT(per_nombre, \' \' , per_paterno, \' \' , per_materno) LIKE ?', "%#{search}%"], :order => "per_paterno, per_materno, per_nombre", :limit => 25)
    else
      find(:all)
    end
  end

end
