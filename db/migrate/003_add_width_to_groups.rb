class AddWidthToGroups < ActiveRecord::Migration

	def self.up
		add_column :ac_groups, :width, :integer, :default => 100
	end

	def self.down
		remove_column :ac_groups, :width
	end

end