#########################################
# = Modelo que sirve base para migración de información
#########################################

class Migracion < ActiveRecord::Base
  establish_connection :migracion
  set_table_name :audiencia
  set_primary_key :cve_aud

  attr_accessor :nombre_completo
  attr_accessor :nombre
  attr_accessor :paterno
  attr_accessor :materno
  attr_accessor :clave_solicitante


  def solicitante(cve_sol=nil)
    cve_sol = self.cve_sol || cve_sol
    self.clave_solicitante ||= cve_sol
    if cve_sol
      Migracion.set_table_name "solicitante"
      Migracion.reset_column_information
      m=  Migracion.find(:first,
        :select => "*, cve_sol,  a_paterno, a_materno, nombre, CONCAT(nombre, \' \' , a_paterno, \' \' , a_materno) as nombre_completox" ,
        :conditions => ["cve_sol = ?", self.clave_solicitante])
      self.nombre = m["nombre"] if m["nombre"]
      self.paterno = m["a_paterno"] if m["a_paterno"]
      self.materno = m["a_materno"] if m["a_materno"]
      nc= ""
#      (nc += "#{m["nombre"]} ")  if self.nombre
#      (nc += "#{m["a_paterno"]} ")  if  self.paterno
#      (nc += "#{m["a_materno"]}")  if  self.materno
        self.nombre_completo =  "#{self.nombre} #{self.paterno} #{self.materno}"
        #puts "NOMBRE COMPLETO EN FUNCION SOLICITANTE: #{self.nombre_completo}"
##      return m
#     # m = Migracion.find_by_sql(["SELECT cve_sol,  a_paterno, a_materno, nombre, CONCAT(nombre, \' \' , a_paterno, \' \' , a_materno) as nombre_completo FROM solicitante WHERE cve_sol = ?", self.clave_solicitante]).first
#      self.paterno = m.a_paterno if m.a_paterno
#      self.paterno = m.a_materno if m.a_materno
#      self.nombre = m.nombre if m.nombre
      return m
    end
  end

  
end
