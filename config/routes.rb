# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
RedmineApp::Application.routes.draw do
	scope '/projects/:project_id/', :as => "project" do
		resources :groups, :controller => 'ac_groups', :as => 'ac_groups' do
			resources :fields, :controller => 'ac_fields', :as => 'ac_fields'
		end
	end
end