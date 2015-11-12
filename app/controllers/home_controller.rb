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
end
