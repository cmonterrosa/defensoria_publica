class TipoJuiciosController < ApplicationController
  require_role [:admin]

  # GET /tipo_juicios
  # GET /tipo_juicios.xml
  def index
    @tipo_juicios = TipoJuicio.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tipo_juicios }
    end
  end

  # GET /tipo_juicios/1
  # GET /tipo_juicios/1.xml
  def show
    @tipo_juicio = TipoJuicio.find(params[:id])

    respond_to do |format|
      format.html {redirect_to :action => "index"}
      format.xml  { render :xml => @tipo_juicio }
    end
  end

  # GET /tipo_juicios/new
  # GET /tipo_juicios/new.xml
  def new
    @tipo_juicio = TipoJuicio.new
    @materias = Materia.all
    respond_to do |format|
      format.html {render :partial => "new_or_edit", :layout => "content"}
      format.xml  { render :xml => @tipo_juicio }
    end
  end

  # GET /tipo_juicios/1/edit
  def edit
    @tipo_juicio = TipoJuicio.find(params[:id])
  end

  # POST /tipo_juicios
  # POST /tipo_juicios.xml
  def create
    @tipo_juicio = TipoJuicio.new(params[:tipo_juicio])
    @materias = Materia.all
    respond_to do |format|
      if @tipo_juicio.save
        format.html { redirect_to(@tipo_juicio, :notice => 'Registro creado correctamente') }
        format.xml  { render :xml => @tipo_juicio, :status => :created, :location => @tipo_juicio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tipo_juicio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_juicios/1
  # PUT /tipo_juicios/1.xml
  def update
    @tipo_juicio = TipoJuicio.find(params[:id])

    respond_to do |format|
      if @tipo_juicio.update_attributes(params[:tipo_juicio])
        format.html { redirect_to(@tipo_juicio, :notice => 'TipoJuicio was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tipo_juicio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_juicios/1
  # DELETE /tipo_juicios/1.xml
  def destroy
    @tipo_juicio = TipoJuicio.find(params[:id])
    @tipo_juicio.destroy

    respond_to do |format|
      format.html { redirect_to(tipo_juicios_url) }
      format.xml  { head :ok }
    end
  end
end
