class AcFieldsController < ApplicationController
  unloadable

  before_filter :set_tracker, only: [:destroy]

  def destroy
  	@field = AcField.find params[:id]

  	if @field.destroy
      flash[:notice] = "Campo personalizado eliminado correctamente."
    else
      flash[:error] = "Error al intentar eliminar el campo personalizado."
    end
   
  	redirect_to edit_project_ac_group_path(:id => params[:ac_group_id], :project_id => params[:project_id], :tracker_id => @tracker.id)
  end

  private
  def set_tracker
  	@tracker = Tracker.find params[:tracker_id]
  end

 end