require 'ac/tracker_patch'

Redmine::Plugin.register :redmine_agrupacion_campos do
  name 'Redmine Agrupacion Campos plugin'
  author 'jresinas, mabalos'
  description 'Plugin de Redmine que permite realizar agrupaciones de campos personalizados en fieldsets.'
  version '0.0.1'
  author_url 'http://www.emergya.es'

  project_module :agrupacion_de_campos do
    permission :ac_edit_groups, :ac_groups => [:index, :new, :create, :edit, :update, :destroy]
  end

  menu :project_menu, :config_agrupacion_campos, { :controller => 'ac_groups', :action => 'index' }, :caption => 'Agrupacion de campos', :last => true, :param => :project_id
end
