class CreateGroups < ActiveRecord::Migration
  def change
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
