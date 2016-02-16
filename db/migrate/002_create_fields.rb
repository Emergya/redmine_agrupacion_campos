class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :ac_fields do |t|
        t.column :custom_field_id, :integer
        t.column :ac_group_id, :integer
        t.column :priority, :integer
    end
  end

  def self.down
    drop_table :ac_fields
  end
end
