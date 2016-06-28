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
	     
		def custom_field_tag_disabled(prefix, custom_value)
		    custom_value.custom_field.format.edit_tag self,
		      custom_field_tag_id(prefix, custom_value.custom_field),
		      custom_field_tag_name(prefix, custom_value.custom_field),
		      custom_value,
		      :class => "#{custom_value.custom_field.field_format}_cf",
		      :disabled => true
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