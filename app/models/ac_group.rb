class AcGroup < ActiveRecord::Base
  unloadable

  has_many :ac_fields, :dependent => :destroy
  belongs_to :tracker
end