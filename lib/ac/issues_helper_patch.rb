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
      	# Metodo que permite mostrar en las peticiones los campos personalizados mediente agrupaciones dentro de fieldsets.

      	# 1º Buscamos si tiene grupos personalizados ese tracker al que pertenece la petición
      	@groups = AcGroup.where('tracker_id = ?', issue.tracker_id)
      	if @groups.count > 0

  			values = issue.visible_custom_field_values
			return if values.empty?
		   	ordered_values = []
		   	half = (values.size / 2.0).ceil
		   	
		   	half.times do |i|
		   		ordered_values << values[i]
		   		ordered_values << values[i + half]
		   	end
		   	
		   	s = "<tr>\n"
		   	s << "<td colspan='4'>"
		   	
		   	@groups.each do |group|
		   		if group.ac_fields.present?
			   		s << "<fieldset>"
			   		s << "<legend>"+group.name+"</legend>"

				   	ordered_values.compact.each do |value|
				   		id_custom_field = value.custom_field.id 
				   		if group.ac_fields.where('custom_field_id = ?',id_custom_field).present?
				   			s << "<b>#{ h(value.custom_field.name) }:</b> #{ simple_format_without_paragraph(h(show_value(value)))}<br>\n"
				   		end
				   	end

		   			s << "</fieldset><br>"
			    end
		   	end

			s << "</tr>\n"
			s.html_safe
      	else
        	render_custom_fields_rows_without_groups_fields
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