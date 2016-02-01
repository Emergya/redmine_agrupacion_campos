require_dependency 'custom_field'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

module AC
  module CustomFieldPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      # Same as typing in the class
      base.class_eval do
        unloadable # Send unloadable so it will be reloaded in development

        has_many :ac_fields, :dependent => :destroy

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
    # use require_dependency if you plan to utilize development mode
    CustomField.send(:include, AC::CustomFieldPatch)
  end
else
  Dispatcher.to_prepare do
    CustomField.send(:include, AC::CustomFieldPatch)
  end
end