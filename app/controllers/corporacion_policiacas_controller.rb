#############################################
# CRUD para corporacion policiacas
#
#############################################
class CorporacionPoliciacasController < ApplicationController
  require_role :admin
  # GET /corporacion_policiacas
  # GET /corporacion_policiacas.xml
  def index
    @corporacion_policiacas = CorporacionPoliciaca.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @corporacion_policiacas }
    end
  end

  # GET /corporacion_policiacas/1
  # GET /corporacion_policiacas/1.xml
  def show
    @corporacion_policiaca = CorporacionPoliciaca.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @corporacion_policiaca }
    end
  end

  # GET /corporacion_policiacas/new
  # GET /corporacion_policiacas/new.xml
  def new
    @corporacion_policiaca = CorporacionPoliciaca.new
    @tipos_corporaciones = TipoCorporacionPoliciaca.all

    respond_to do |format|
      format.html { render :partial => "new_or_edit", :layout => "content" }
      format.xml  { render :xml => @corporacion_policiaca }
    end
  end

  

  # GET /corporacion_policiacas/1/edit
  def edit
    @corporacion_policiaca = CorporacionPoliciaca.find(params[:id])
    @tipos_corporaciones = TipoCorporacionPoliciaca.all
    respond_to do |format|
      format.html { render :partial => "new_or_edit", :layout => "content" }
      format.xml  { render :xml => @corporacion_policiaca }
    end
  end

  # POST /corporacion_policiacas
  # POST /corporacion_policiacas.xml
  def create
    @corporacion_policiaca = CorporacionPoliciaca.new(params[:corporacion_policiaca])

    respond_to do |format|
      if @corporacion_policiaca.save
        format.html { redirect_to(@corporacion_policiaca, :notice => 'Registro guardado correctamente.') }
        format.xml  { render :xml => @corporacion_policiaca, :status => :created, :location => @corporacion_policiaca }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @corporacion_policiaca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /corporacion_policiacas/1
  # PUT /corporacion_policiacas/1.xml
  def update
    @corporacion_policiaca = CorporacionPoliciaca.find(params[:id])

    respond_to do |format|
      if @corporacion_policiaca.update_attributes(params[:corporacion_policiaca])
        format.html { redirect_to(@corporacion_policiaca, :notice => 'Registro actualizado correctamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @corporacion_policiaca.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /corporacion_policiacas/1
  # DELETE /corporacion_policiacas/1.xml
  def destroy
    @corporacion_policiaca = CorporacionPoliciaca.find(params[:id])
    if @corporacion_policiaca.participantes.empty?
      @corporacion_policiaca.destroy
       flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:error] = "Registro no se pudo eliminar"
    end

    respond_to do |format|
      format.html { redirect_to(corporacion_policiacas_url) }
      format.xml  { head :ok }
    end
  end
end
