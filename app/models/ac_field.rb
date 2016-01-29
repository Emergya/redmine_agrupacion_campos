class AcField < ActiveRecord::Base
  unloadable

  belongs_to :ac_group
end