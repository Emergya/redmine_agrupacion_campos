class AcField < ActiveRecord::Base
  unloadable

  belongs_to :ac_group
  belongs_to :custom_field
end