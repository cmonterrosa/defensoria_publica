require 'rubygems'
require 'uuidtools'


module UUIDHelper
    # Asigna un UUID a la persona en base a la hora actual
    def before_create()
        self.id_persona = UUIDTools::UUID.timestamp_create().to_s
    end
end
