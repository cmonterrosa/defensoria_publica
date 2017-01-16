class TipoSentencia < ActiveRecord::Base
	has_many :sentencias

  named_scope :penal, :conditions => {:tipo_penal => true}
  named_scope :nopenal, :conditions => {:tipo_penal => false}


end
