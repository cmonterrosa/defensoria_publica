class Bitacora < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
end
