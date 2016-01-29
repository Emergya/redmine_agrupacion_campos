class AcGroupsController < ApplicationController
  unloadable

  menu_item :config_agrupacion_campos
  before_filter :find_project_by_project_id, :authorize

  def index

  end

end