require_dependency 'custom_fields_helper'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

# Patches Redmine's ApplicationController dinamically. Redefines methods wich
# send error responses to clients
module AC
  module CustomFieldsHelperPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable  # Send unloadable so it will be reloaded in development
	     
	    def custom_field_tag_disabled(name, custom_value)
		    custom_field = custom_value.custom_field
		    field_name = "#{name}[custom_field_values][#{custom_field.id}]"
		    field_name << "[]" if custom_field.multiple?
		    field_id = "#{name}_custom_field_values_#{custom_field.id}"

		    tag_options = {:id => field_id, :class => "#{custom_field.field_format}_cf", :disabled => true}

		    field_format = Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)
		    case field_format.try(:edit_as)
		    when "date"
		      text_field_tag(field_name, custom_value.value, tag_options.merge(:size => 10)) +
		      calendar_for(field_id)
		    when "text"
		      text_area_tag(field_name, custom_value.value, tag_options.merge(:rows => 3))
		    when "bool"
		      hidden_field_tag(field_name, '0') + check_box_tag(field_name, '1', custom_value.true?, tag_options)
		    when "list"
		      blank_option = ''.html_safe
		      unless custom_field.multiple?
		        if custom_field.is_required?
		          unless custom_field.default_value.present?
		            blank_option = content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---", :value => '')
		          end
		        else
		          blank_option = content_tag('option')
		        end
		      end
		      s = select_tag(field_name, blank_option + options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.value),
		        tag_options.merge(:multiple => custom_field.multiple?))
		      if custom_field.multiple?
		        s << hidden_field_tag(field_name, '')
		      end
		      s
		    else
		      text_field_tag(field_name, custom_value.value, tag_options)
		    end
		end

      	def custom_field_tag_with_label_disabled(name, custom_value, options={})
      		custom_field_label_tag(name, custom_value, options) + custom_field_tag_disabled(name, custom_value)
      	end
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    CustomFieldsHelper.send(:include, AC::CustomFieldsHelperPatch)
  end
else
  Dispatcher.to_prepare do
    CustomFieldsHelper.send(:include, AC::CustomFieldsHelperPatch)
   end
end