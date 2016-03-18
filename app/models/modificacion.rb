class Modificacion < ActiveRecord::Base
  #belongs_to :tramite, :class_name => 'Tramite', :foreign_key => "objeto_id"
  has_many :modificacion_detalles
  belongs_to :user
end
