################################################
# = Controlador que administra las adscripciones
################################################
class AdscripcionsController < ApplicationController
  require_role :admin
  # GET /adscripcions
  # GET /adscripcions.xml
  def index
    @adscripcions = Adscripcion.all.paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html { render :partial => "list", :layout => "content"}
      format.xml  { render :xml => @adscripcions }
    end
  end

   def usuarios
    @adscripcion = Adscripcion.find(params[:id])
    @usuarios = @adscripcion.users
   end

  # GET /adscripcions/1
  # GET /adscripcions/1.xml
  def show
    @adscripcion = Adscripcion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @adscripcion }
    end
  end

  # Búsqueda de defensores por nombre o apellidos
  def search
    @adscripciones = Adscripcion.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end


  # GET /adscripcions/new
  # GET /adscripcions/new.xml
  def new
    @adscripcion = Adscripcion.new

    respond_to do |format|
      format.html { render :partial => "new_or_edit", :layout => "content"}
      format.xml  { render :xml => @adscripcion }
    end
  end

  # GET /adscripcions/1/edit
  def edit
    @adscripcion = Adscripcion.find(params[:id])
    respond_to do |format|
      format.html { render :partial => "new_or_edit", :layout => "content"}
      format.xml  { render :xml => @adscripcion }
    end
  end

  # POST /adscripcions
  # POST /adscripcions.xml
  def save
    @adscripcion = Adscripcion.find(params[:id]) if params[:id] || Adscripcion.new(params[:adscripcion])

    respond_to do |format|
      if @adscripcion.save
        format.html { redirect_to(@adscripcion, :notice => 'Adscripcion was successfully created.') }
        format.xml  { render :xml => @adscripcion, :status => :created, :location => @adscripcion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @adscripcion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /adscripcions/1
  # PUT /adscripcions/1.xml
  def update
    @adscripcion = Adscripcion.find(params[:id])

    respond_to do |format|
      if @adscripcion.update_attributes(params[:adscripcion])
        format.html { redirect_to(@adscripcion, :notice => 'Adscripcion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @adscripcion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /adscripcions/1
  # DELETE /adscripcions/1.xml
  def destroy
    @adscripcion = Adscripcion.find(params[:id])
    unless @adscripcion.users.empty?
      @adscripcion.destroy
    end

    respond_to do |format|
      format.html { redirect_to(adscripcions_url) }
      format.xml  { head :ok }
    end
  end
end
