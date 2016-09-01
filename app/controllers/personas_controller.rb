class PersonasController < ApplicationController
  require_role [:admin, :jefedefensor]
  # GET /personas
  # GET /personas.xml
  def index
    @participantes = Participante.find(:all, :select => "persona_id")
    @audiencias = Participante.find(:all, :select => "persona_id")

    @personas = Persona.find(:all, :conditions => ["id_persona in (?)", (@participantes + @audiencias).map{|i|i.persona_id}]).paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
#      format.html # index.html.erb
      format.html {render :partial => "list", :layout => "content"}
      format.xml  { render :xml => @personas.to_xml }
      format.json { render :xml => @personas.to_json }
    end
  end

   def search
    @search = params[:search]
    @personas = Persona.search(params[:search]).paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "content"
  end

  # GET /personas/1
  # GET /personas/1.xml
  def show
    @persona = Persona.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @persona }
      format.json  { render :json => @persona.to_json }
    end
  end

  # GET /personas/new
  # GET /personas/new.xml
  def new
    @persona = Persona.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @persona }
    end
  end

  # GET /personas/1/edit
  def edit
    @persona = Persona.find(params[:id])
  end

  # POST /personas
  # POST /personas.xml
  def save
    @persona = Persona.find(params[:id]) if params[:id]
    @persona ||= Persona.new(params[:persona])
    @persona.prepare_row(params,current_user)
    respond_to do |format|
      if @persona.save
        format.html { redirect_to(@persona, :notice => 'Persona was successfully created.') }
        format.xml  { render :xml => @persona, :status => :created, :location => @persona }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @persona.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activity
    begin
      @persona = Persona.find(params[:id])
      @participantes = Participante.find(:all, :conditions => ["persona_id = ?", @persona.id])
      @audiencias = Audiencia.find(:all, :conditions => ["persona_id = ?", @persona.id])
    rescue
      flash[:error] = "No se encontro persona, verifique"
      redirect_to(:back)
    end
  end

  # PUT /personas/1
  # PUT /personas/1.xml
  def update
    @persona = Persona.find(params[:id])

    respond_to do |format|
      #@persona.attributes = params[:persona] if params[:persona]
      
      if @persona.update_attributes(params[:persona])
        format.html { redirect_to(@persona, :notice => 'Persona was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @persona.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personas/1
  # DELETE /personas/1.xml
  def destroy
    @persona = Persona.find(params[:id])
    @persona.destroy

    respond_to do |format|
      format.html { redirect_to(personas_url) }
      format.xml  { head :ok }
    end
  end
end
