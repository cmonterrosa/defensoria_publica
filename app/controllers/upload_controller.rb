############################################
# Controlador que se encarga principalmente de manejar los
# archivos adjuntos del tramite y/o participante
#
############################################

class UploadController < ApplicationController
  require_role [:defensor, :admin, :subdireccion], :for => [:destroy, :download]

  def index
    (params[:token] == "p" || params[:p])? @participante = Participante.find(params[:p]) : @tramite = Tramite.find(params[:t])
    @title = (@participante) ? "ARCHIVOS ADJUNTOS DEL PARTICIPANTE: #{@participante.id}" : "ARCHIVOS ADJUNTOS DEL TRAMITE: #{@tramite.id}"
    @uploaded_files = @tramite.adjuntos.paginate(:page => params[:page], :per_page => 10) if @tramite
    render :partial => "list", :layout => "only_javascript"
  end

   def new_or_edit
    (params[:token] == "p" || params[:p] )? @participante = Participante.find(params[:p]) : @tramite = Tramite.find(params[:t])
    @uploaded_file  = Adjunto.find(params[:id]) if params[:id]
    @uploaded_file  ||= Adjunto.new
    render :partial => "new", :layout => "only_jquery"
  end

  def create
    @uploaded_file =Adjunto.new(params[:adjunto])
    (params[:token] == "p" || params[:p] )? @participante = Participante.find(params[:p]) : @tramite = Tramite.find(params[:t])
    #@ruta = (params[:token] == "p")? {:action => "index", :id => @uploaded_file.participante.id} : {:action => "index", :id => @uploaded_file.tramite.id}
    @uploaded_file.tramite_id = @tramite.id if @tramite
    @uploaded_file.participante_id = @participante.id if @participante
    @uploaded_file.user_id ||= current_user.id if current_user
    if @uploaded_file.save
      flash[:notice] = "Archivo cargado correctamente"
       redirect_to :action => "index", :t => @tramite, :p => @participante
    else
       flash[:notice] = "El archivo no fue cargado correctamente"
       render :action => "new_or_edit"
    end
  end



  ################################################
  #
  #                           ACCIONES CRUD
  #
  ################################################



   def destroy
      @uploaded_file = Adjunto.find(params[:id])
      flash[:notice] = (@uploaded_file.destroy) ?   "Archivo eliminado correctamente" :  "No se puedo eliminar, verifique"
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

  def preview_image
    @uploaded_file  = Adjunto.find(params[:id])
    render :partial => "preview_image", :layout => "only_jquery"
  end
  
end


