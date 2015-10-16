# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
require 'uuidtools'

module UUIDHelper
    def before_create()
        self.id_persona = UUIDTools::UUID.timestamp_create().to_s
    end
end
