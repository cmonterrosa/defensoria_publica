class HomeController < ApplicationController
 before_filter :login_required
 
  def index
    redirect_to :action => "dispatch"
  end

  # Método que se encarga de enlazar usuario con el menu que le corresponde de acuerdo al role
    def dispatch
      @usuario=current_user
      if @usuario.has_role?(:admin)
          return render(:partial => 'admin', :layout => "content")
      elsif @usuario.has_role?(:directivo)
          return render(:partial => 'directivo', :layout => "content")
      elsif @usuario.has_role?(:jefedefensor)
          return render(:partial => 'jefedefensor', :layout => "content")
      elsif @usuario.has_role?(:defensorpenal)
          return render(:partial => 'defensorpenal', :layout => "content")
      elsif @usuario.has_role?(:defensorapoyo)
          return render(:partial => 'defensor', :layout => "content")
      elsif @usuario.has_role?(:defensor)
          return render(:partial => 'defensor', :layout => "content")
      elsif @usuario.has_role?(:solicitante)
          return render(:partial => 'solicitante', :layout => "content")
      elsif @usuario.has_role?(:recepcion)
          return render(:partial => 'recepcion', :layout => "content")
      else
          return render(:partial => 'default', :layout => "content")
      end
    end

    # Devuelve los datos de configuracion de la cuenta actual
    def myaccount
      @user = current_user
    end


    def get_datos_personales_minimos
        get_datos_personales('minimals')
    end

    # Obtiene los datos personales, o crea un registro nuevo de persona
    def get_datos_personales(tipo=nil)
      @persona ||= Persona.new
      #@contacto ||= Contacto.new
      @tipo = tipo
      partial_persona = (@tipo)? 'datos_personales_minimos' : 'datos_personales'
      if params[:persona_per_curp] && params[:persona_per_curp].size >= 6
        if @persona = Persona.find(:first, :conditions => ["per_curp like ?", "#{params[:persona_per_curp]}%"])
          @contacto = Contacto.find(:first, :conditions => ["fk_persona = ?", @persona.id]) if @persona
          return render(:partial => partial_persona, :layout => false) if request.xhr?
        else
          if @personas = Persona.search(params[:persona_per_curp])
            if @personas.empty?
              if current_user.has_role?(:defensorapoyo)
                return render(:partial => 'datos_personales', :layout => 'only_jquery') if request.xhr?
              else                 
                return render(:partial => 'datos_personales', :layout => 'only_jquery') if request.xhr?
              end
            else
              return render(:partial => 'seleccion_persona', :layout => 'only_jquery') if request.xhr?
            end
            else
              return render(:partial => partial_persona, :layout => 'only_jquery') if request.xhr?
            end
        end
        else
            @persona = Persona.find(params[:persona_id]) if (params[:persona_id] && params[:persona_id].size == 36)
            return render(:partial => partial_persona, :layout => false) if request.xhr?
        end
      end

     def get_datos_tramite
        if params[:tramite_identificador] && params[:tramite_identificador].size > 2
          if @tramites = Tramite.search(params[:tramite_identificador])
             if @tramites.size == 1
                 @tramite = @tramites.first
                 return render(:partial => 'datos_tramite', :layout => false) if request.xhr?
            else
                 return render(:partial => 'seleccion_tramite', :layout => false) if request.xhr?
             end
          else
            render :text => "No se encontraron tramites existentes, verifique"
          end
        else
           render :text => "Teclee cuando menos dos caracteres"
        end
     end

  end