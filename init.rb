require 'ac/tracker_patch'
require 'ac/issue_patch'
require 'ac/issues_helper_patch'
require 'ac/custom_fields_helper_patch'

Redmine::Plugin.register :redmine_agrupacion_campos do
  name 'Redmine Agrupacion Campos plugin'
  author 'jresinas, mabalos'
  description 'Plugin de Redmine que permite realizar agrupaciones de campos personalizados en fieldsets.'
  version '0.2.0'
  author_url 'http://www.emergya.es'

  requires_redmine_plugin :adapter_deface, :version_or_higher => '0.0.1'

  project_module :agrupacion_de_campos do
    permission :ac_edit_groups, :ac_groups => [:index, :new, :create, :edit, :update, :destroy]
    permission :ac_edit_fields, :ac_fields => [:destroy]
  end

  menu :project_menu, :config_agrupacion_campos, { :controller => 'ac_groups', :action => 'index' }, :caption => 'Agrupacion de campos', :last => true, :param => :project_id
end
