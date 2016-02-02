class AcGroupsController < ApplicationController
  unloadable

  menu_item :config_agrupacion_campos
  before_filter :find_project_by_project_id, :authorize

  before_filter :set_tracker, only: [:new, :edit]
  before_filter :set_group, only: [:edit, :update, :destroy]
  before_filter :get_custom_fields, only: [:new, :edit]

  def index
  	@trackers = @project.trackers
  end

  def new
  	@group = AcGroup.new

  	# Inicializando para mostrar el fieldset del primer campo personalizado.
  	@field = []
    (0...1).each do |i|
      @field[i] = AcField.new(:id => i) 
    end

     @count_fields = 0
  end

  def create
    @group = AcGroup.new params[:ac_group]

    if @group.save
      flash[:notice] = "La agrupacion de campos se ha guardado con exito."
      redirect_to project_ac_groups_path(:project_id => @project)
    else
      flash[:error] = @group.get_error_message
      redirect_to action: 'new', :project_id => @project, :tracker_id => params[:ac_group][:tracker_id]
    end
  end

  def edit
    @field = @group.ac_fields
  	@count_fields = @group.ac_fields.count
  end

  def update
    if @group.update_attributes(params[:ac_group]) 
      flash[:notice] = "La agrupacion se ha modificado con exito."
      redirect_to project_ac_groups_path(:project_id => @project)
    else
      flash[:error] = @group.get_error_message
      redirect_to action: 'edit', :project_id => @project
    end
  end

  def destroy
  	if @group.destroy
      flash[:notice] = "La agrupacion se ha eliminado correctamente."
    else
      flash[:error] = "Error al intentar eliminar la agrupacion."
    end

    redirect_to project_ac_groups_path(:project_id => @project)
  end

  private
  def set_group
	@group = AcGroup.find params[:id]
  end

  def set_tracker
  	@tracker = Tracker.find params[:tracker_id]
  end

  def get_custom_fields
    @custom_fields_by_tracker = @tracker.custom_fields.uniq.map{|field| [field.name, field.id]}
  end

end