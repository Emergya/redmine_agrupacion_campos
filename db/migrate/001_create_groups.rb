class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :ac_groups do |t|
        t.column :name, :string
        t.column :priority, :integer
        t.column :tracker_id, :integer
    end
  end

  def self.down
    drop_table :ac_groups
  end
end
