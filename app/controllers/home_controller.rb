class HomeController < ApplicationController
 before_filter :login_required
 
  def index
    redirect_to :action => "dispatch"
  end

    def dispatch
      @usuario=current_user
      if @usuario.has_role?(:admin)
          return render(:partial => 'admin', :layout => "content")
      elsif @usuario.has_role?(:jefedefensor)
          return render(:partial => 'jefedefensor', :layout => "content")
      elsif @usuario.has_role?(:defensor)
          return render(:partial => 'defensor', :layout => "content")
      elsif @usuario.has_role?(:defensorapoyo)
          return render(:partial => 'defensor', :layout => "content")
      elsif @usuario.has_role?(:solicitante)
          return render(:partial => 'solicitante', :layout => "content")
      else
          return render(:partial => 'default', :layout => "content")
      end
    end

    def myaccount
      @user = current_user
    end

    def get_datos_personales
      @persona ||= Persona.new
      #@contacto ||= Contacto.new
      if params[:persona_per_curp] && params[:persona_per_curp].size >= 6
        if @persona = Persona.find(:first, :conditions => ["per_curp like ?", "#{params[:persona_per_curp]}%"])
          @contacto = Contacto.find(:first, :conditions => ["fk_persona = ?", @persona.id]) if @persona
          return render(:partial => 'datos_personales', :layout => false) if request.xhr?
        else
          if @personas = Persona.search(params[:persona_per_curp])
            if @personas.empty?
              if current_user.has_role?(:defensorapoyo)
                return render(:partial => 'datos_personales_compacto', :layout => false) if request.xhr?
              else                 
                return render(:partial => 'datos_personales', :layout => false) if request.xhr?
              end
            else
              return render(:partial => 'seleccion_persona', :layout => false) if request.xhr?
            end
            else
              return render(:partial => 'datos_personales', :layout => false) if request.xhr?
            end
        end
        else
            @persona = Persona.find(params[:persona_id]) if (params[:persona_id] && params[:persona_id].size == 36)
            return render(:partial => 'datos_personales', :layout => false) if request.xhr?
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
