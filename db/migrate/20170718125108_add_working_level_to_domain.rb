class AddWorkingLevelToDomain < ActiveRecord::Migration[5.0]
	def change
		add_column :domains, :working_level, :integer
	end
end
