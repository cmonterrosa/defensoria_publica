class Organo < ActiveRecord::Base
  set_primary_key "id_organo"
  has_many :audiencia_orals
end
