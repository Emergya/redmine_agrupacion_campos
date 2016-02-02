class AcGroup < ActiveRecord::Base
  unloadable

  has_many :ac_fields, :dependent => :destroy
  belongs_to :tracker
  accepts_nested_attributes_for :ac_fields

  validate :check_name_group_empty
  validate :check_priority_group_empty
  validate :check_priority_field_empty

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

  private

  # Valida que se ha introducido un nombre para la nueva agrupación.
  def check_name_group_empty
    errors.add :base, l(:"group.error.name_is_empty") if self.name.blank?
  end

  # Valida que se ha introducido una prioridad para esa agrupación.
  def check_priority_group_empty
    errors.add :base, l(:"group.error.priority_is_empty") if self.priority.blank?
  end

  # Valida que se ha introducido una prioridad para los campos personalizados.
  def check_priority_field_empty
    is_blank = false
    self.ac_fields.each do |field|
      is_blank = true if field.priority.blank?
    end

    errors.add :base, l(:"field.error.priority_is_empty") if is_blank == true
  end
  
end