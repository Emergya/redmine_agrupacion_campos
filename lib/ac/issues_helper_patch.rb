require_dependency 'issues_helper'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

# Patches Redmine's ApplicationController dinamically. Redefines methods wich
# send error responses to clients
module AC
  module IssuesHelperPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable  # Send unloadable so it will be reloaded in development

        alias_method_chain :render_custom_fields_rows, :groups_fields
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def render_custom_fields_rows_with_groups_fields(issue)
      	# Metodo que permite mostrar los campos personalizados mediente agrupaciones dentro de fieldsets.

      	# Buscamos si tiene grupos personalizados ese tracker al que pertenece la petición
      	@groups = issue.tracker.ac_groups
      	if @groups.count > 0 && @project.module_enabled?(:agrupacion_de_campos)

      		values = issue.visible_custom_field_values
    			return if values.blank?

          map_values = values.index_by(&:custom_field_id)
          cf_used = []
	   	
    		  s = "<tr>\n"
    		  s << "<td colspan='4'><br>"
    		  
    		  @groups.order("priority ASC").each do |group|
    		  	
    		  	# Muestra los campos personalizados que estan asignados a ningún grupo.
    		  	if group.ac_fields.present?
    			 		s << "<fieldset>"
    			 		s << "<legend>"+group.name+"</legend>"

              group.ac_fields.order("priority ASC").each do |cf|
                if map_values.keys.include?(cf.custom_field_id)
                  cf_used << cf.custom_field_id
                  value = map_values[cf.custom_field_id]
                    s << "<br><b><div style='width: 200px; float: left'>#{ h(value.custom_field.name) }:</div></b>"
                    if show_value(value).blank?
                      s << "<div>-</div>\n"
                    else
                      s << "<div>#{ simple_format_without_paragraph(h(show_value(value)))}</div>\n"
                    end
                end
              end

    		  		s << "<br></fieldset><br>"
    			  end
          end

          # Muestra los campos personalizados que no estan asignados a un grupo
          cf_used.uniq!

          values.compact.each do |value|
            if !cf_used.include?(value.custom_field_id)
              s << "<br><b><div style='width: 200px; float: left'>#{ h(value.custom_field.name) }:</div></b>"
              if show_value(value).blank?
                s << "<div>-</div>\n"
              else
                s << "<div>#{ simple_format_without_paragraph(h(show_value(value)))}</div>\n"
              end
            end
          end


    			s << "</tr>\n"
    			s.html_safe
      	else
        	render_custom_fields_rows_without_groups_fields(issue)
    	  end
      end
    end
  end
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    IssuesHelper.send(:include, AC::IssuesHelperPatch)
  end
else
  Dispatcher.to_prepare do
    IssuesHelper.send(:include, AC::IssuesHelperPatch)
   end
end