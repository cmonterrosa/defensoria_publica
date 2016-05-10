class EstatusController < ApplicationController
  require_role :admin
  # GET /estatus
  # GET /estatus.xml
  def index
    @estatus = Estatu.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @estatus }
    end
  end

  # GET /estatus/1
  # GET /estatus/1.xml
  def show
    @estatu = Estatu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @estatu }
    end
  end

  # GET /estatus/new
  # GET /estatus/new.xml
  def new
    @estatu = Estatu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @estatu }
    end
  end

  # GET /estatus/1/edit
  def edit
    @estatu = Estatu.find(params[:id])
  end

  # POST /estatus
  # POST /estatus.xml
  def create
    @estatu = Estatu.new(params[:estatu])

    respond_to do |format|
      if @estatu.save
        format.html { redirect_to(@estatu, :notice => 'Registro creado correctamente.') }
        format.xml  { render :xml => @estatu, :status => :created, :location => @estatu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @estatu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /estatus/1
  # PUT /estatus/1.xml
  def update
    @estatu = Estatu.find(params[:id])

    respond_to do |format|
      if @estatu.update_attributes(params[:estatu])
        format.html { redirect_to(@estatu, :notice => 'Registro actualizado correctamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @estatu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /estatus/1
  # DELETE /estatus/1.xml
  def destroy
    @estatu = Estatu.find(params[:id])
    @estatu.destroy

    respond_to do |format|
      format.html { redirect_to(estatus_url) }
      format.xml  { head :ok }
    end
  end
end
