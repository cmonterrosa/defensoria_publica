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
      if params[:persona_per_curp] && params[:persona_per_curp].size >= 6
        if @persona = Persona.find(:first, :conditions => ["per_curp like ?", "#{params[:persona_per_curp]}%"])
          return render(:partial => 'datos_personales', :layout => false) if request.xhr?
        else
          if @personas = Persona.search(params[:persona_per_curp])
            if @personas.empty?
                      return render(:partial => 'datos_personales', :layout => false) if request.xhr?
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
  end
