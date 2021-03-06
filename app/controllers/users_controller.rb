class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  before_filter :login_required, :except => [:new, :save]
  # render new.rhtml


  def new
    redirect_to :action => "new_or_edit"
  end

  def edit
    @user = (params[:id])? User.find(params[:id]) : nil if current_user.has_role?(:admin)
    @user ||= current_user
    render :partial => "edit", :layout => "content"
  end

 
  def new_or_edit
    @user = (params[:id])? User.find(params[:id]) : User.new
    if @persona = @user.persona
      @per_curp = @persona.per_curp if @persona.per_curp.size > 0
      @per_curp ||= @persona.nombre_completo
    end
    render :partial => "new_or_edit", :layout => "content"
  end

  def save
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.update_attributes(params[:user])
    if params[:persona]
      @user.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
      @user.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
    end    
    @user.persona ||= Persona.new(params[:persona])
    @user.activo = (params[:user] && params[:user][:activo] == 'SI') ? true : false
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      #flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
 
  def create
    #logout_keeping_session!
    @user = (params[:id] && params[:id].size > 0)? User.find(params[:id]) :  User.new(params[:user])
    @user.update_attributes(params[:user])
    if params[:persona]
      @user.persona = (params[:persona][:id_persona] && params[:persona][:id_persona].size > 0)? Persona.find(params[:persona][:id_persona]) : nil
      @user.persona ||= (params[:persona][:per_curp] && params[:persona][:per_curp].size > 0) ? Persona.find(:first, :conditions => ["per_curp =  ?", params[:persona][:per_curp]]) : nil
    end    
    @user.persona ||= Persona.new(params[:persona])    
    @user.activo = (params[:user] && params[:user][:activo] == 'SI') ? true : false
    success = @user && @user.save
    if success && @user.errors.empty?
      #redirect_back_or_default('/')
      #redirect_to :action => "users_index", :controller => "admin"
      redirect_to(:back)
      flash[:notice] = "Usuario guardado correctamente"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
