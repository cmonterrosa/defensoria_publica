##############################################
# Controlador que hace administra la aplicación
#
##############################################

class AdminController < ApplicationController
  require_role :admin

  def index
  end

  def users_index
    @users = User.find(:all).paginate(:page => params[:page], :per_page => 25)
    render :partial => "users_list", :layout => "content"
  end
  
  def roles_index
      @roles = Role.find(:all, :order => "prioridad").paginate(:page => params[:page], :per_page => 25)
      render :partial => "roles_list", :layout => "content"
  end

  def role_new_or_edit
    @role = Role.find(params[:id]) if params[:id]
    @role ||= Role.new
  end

  def role_save
    @role = Role.find(params[:id]) if params[:id]
    @role ||= Role.new
    @role.update_attributes(params[:role])
    sucess=@role.save
    if sucess && @role.errors.empty?
        flash[:notice] = "Rol creado correctamente"
        redirect_to :action => "roles_index"
    else
       flash[:error] = "No se puedo guardar, verifique"
       render :action => "role_new_or_edit"
    end
  end
  
  def roles_estatus
    @role = Role.find(params[:id]) if params[:id]
  end

  def users_search
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "users_list", :layout => "content"
  end

  def roles_search
    @roles = Role.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "roles_list", :layout => "content"
  end

  def filtro_role
    if params[:role][:id].size > 0
      @role = Role.find(params[:role][:id])
      return render(:partial => 'estatus_by_role', :layout => 'content') #if request.xhr?
    else
      render :text => "No se pudo realizar la búsqueda, verifique"
    end
  end

  def update_role_estatus
    @role = Role.find(params[:id])
    @role.estatus = []
    @role.estatus =  Estatu.find(params[:estatu][:role_ids]) if params[:estatu][:role_ids]
    if @role.save
      flash[:notice] = "Estatus actualizado correctamente"
      redirect_to :action => "roles_estatus"
    end
  end

  ##########################################
  #        Administracion de Roles y Usuarios
  #
  ##########################################
  
  def users_by_role
    @role = Role.find(params[:id])
    @users = @role.no_users
  end

 def roles_by_user
   @user = User.find(params[:id])
   @roles = @user.roles
   @roles_no_incluidos = Role.find(:all) if @user && @user.roles.empty?
   @roles_no_incluidos ||= Role.find(:all, :conditions => ["id NOT IN (?)", @roles.map{|i|i.id}])
 end

  def add_user
    @role = Role.find(params[:role])
    @role.users << User.find(params[:user][:user_id])
    if @role.save
      flash[:notice] = "Usuario agregado correctamente"
    else
      flash[:error] = "El usuario no fue agregado, verifique"
    end
    redirect_to :action => "users_by_role", :id => @role
  end

    def add_role_to_user
    @user = User.find(params[:user])
    @user.roles << Role.find(params[:role][:role_id])
    if @user.save
      flash[:notice] = "Perfil agregado correctamente al usuario"
    else
      flash[:error] = "El perfil no fue agregado al usuario"
    end
      redirect_to :action => "roles_by_user", :id => @user
  end

    def delete_role_to_user
      @user = User.find(params[:id])
      @role = Role.find(params[:role])
      if @user.roles.delete(@role)
        flash[:notice] = "Perfil removido correctamente al usuario"
      else
        flash[:error] = "El perfil no fue removido al usuario"
      end
        redirect_to :action => "roles_by_user", :id => @user
    end

  def new_user
    @users = Role.find(params[:id]).active_users
  end

  def delete_user
    @role = Role.find(params[:role])
    @user = User.find(params[:id])
     @role.users.delete(@user)
     if @role.save!
       flash[:notice] = "Elemento eliminado del perfil correctamente"
     else
       flash[:error] = "No se pudo eliminar, verifique"
     end
      redirect_to :action => "users_by_role", :id => @role
  end

  def show_roles
    @roles = Role.find(:all)
  end

  def enable_disable_user
    begin
      @user = User.find(params[:id])
      (@user.activo) ? @user.update_attributes!(:activo => false) : @user.update_attributes!(:activo => true)
      @mensaje = @user.activo ? "Usuario habilitado" : "Usuario deshabilitado"
      flash[:notice] = @mensaje
      redirect_to :action => "users_index"
    rescue ActiveRecord::RecordNotFound
        redirect_to  :action => "index"
    end
  end

end
