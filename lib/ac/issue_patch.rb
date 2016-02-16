require_dependency 'issue'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

module AC
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      # Same as typing in the class
      base.class_eval do
        unloadable # Send unloadable so it will be reloaded in development
        validates_presence_of :notes, on: :update
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
    Issue.send(:include, AC::IssuePatch)
  end
else
  Dispatcher.to_prepare do
    Issue.send(:include, AC::IssuePatch)
  end
end