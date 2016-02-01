class AcGroup < ActiveRecord::Base
  unloadable

  has_many :ac_fields, :dependent => :destroy
  belongs_to :tracker
  accepts_nested_attributes_for :ac_fields

  # Genera mensaje de error
  def get_error_message
    error_msg = ""
    self.errors.full_messages.each do |msg|
      if error_msg != ""
        error_msg << "<br>"
      end
      error_msg << msg
    end

    error_msg
  end
  
end