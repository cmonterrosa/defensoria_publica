############################################
# Controlador que se encarga principalmente de manejar los
# archivos adjuntos del tramite y/o participante
#
############################################

class UploadController < ApplicationController
  require_role [:defensor, :admin, :subdireccion], :for => [:destroy, :download]

  def index
    @participante = (params[:token] == "p" || params[:p] )?  Participante.find(params[:p]) : nil
    @tramite = ( params[:t] )?  Tramite.find(params[:t]) : nil
    @title = (@participante) ? "ARCHIVOS ADJUNTOS DEL PARTICIPANTE: #{@participante.id}" : nil
    @title ||= (@tramite) ? "ARCHIVOS ADJUNTOS DEL TRAMITE: #{@tramite.id}" : nil
    @title ||= "PORTAL DE DOCUMENTOS COMPARTIDOS"
    @uploaded_files = @tramite.adjuntos.paginate(:page => params[:page], :per_page => 10) if @tramite
    @uploaded_files ||= @participante.adjuntos.paginate(:page => params[:page], :per_page => 10) if @participante
    @uploaded_files ||= Adjunto.find(:all, :conditions => ["activo = ? AND tramite_id IS NULL and participante_id IS NULL", true]).paginate(:page => params[:page], :per_page => 10) if current_user
    render :partial => "list", :layout => "only_javascript"
  end


  #################################################
  #
  #                           ACCIONES CRUD
  #
  ################################################


  
  def new_or_edit
    @participante = (params[:token] == "p" || params[:p] )?  Participante.find(params[:p]) : nil
    @tramite = ( params[:t] )?  Tramite.find(params[:t]) : nil
    @uploaded_file  = Adjunto.find(params[:id]) if params[:id]
    @uploaded_file  ||= Adjunto.new
    render :partial => "new", :layout => "only_jquery"
  end

  def create
    @uploaded_file =Adjunto.new(params[:adjunto])
    @participante = (params[:token] == "p" || params[:p] )? Participante.find(params[:p]) : nil
    @tramite = ( params[:t] )? Tramite.find(params[:t]) : nil
    @uploaded_file.tramite_id = @tramite.id if @tramite
    @uploaded_file.participante_id = @participante.id if @participante
    @uploaded_file.user_id ||= current_user.id if current_user
    begin
      if @uploaded_file.save
        flash[:notice] = "Archivo cargado correctamente"
        redirect_to :action => "index", :t => @tramite, :p => @participante
      else
        flash[:notice] = "El archivo no fue cargado correctamente"
        rrender :partial => "new", :layout => "only_jquery"
      end
    rescue ActiveRecord::RecordInvalid => invalid
        @errores = invalid.record.errors.full_messages
        render :partial => "new", :layout => "only_jquery"
    end
  end

  def destroy
      @uploaded_file = Adjunto.find(params[:id])
       if (@uploaded_file.user == current_user) && (@uploaded_file.mark_as_deleted)
         flash[:notice] = "Archivo eliminado correctamente"
       else
         flash[:warning] = "No se puedo eliminar porque no tiene privilegios de hacerlo, contacte al administrador"
       end
     redirect_to :action => "index", :t => @uploaded_file.tramite_id, :p => @uploaded_file.participante_id
   end


  def download
    @uploaded_file  = Adjunto.find(params[:id])
     if File.exists?(@uploaded_file.full_path)
        send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
     else
       flash[:error] = "No existe el archivo, contacte al administrador"
       redirect_to(:back)
    end
  end

  # Previ
  def preview_image
    @uploaded_file  = Adjunto.find(params[:id])
    render :partial => "preview_image", :layout => "only_jquery"
  end
  
end


