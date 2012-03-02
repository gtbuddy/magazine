class CreateImages < ActiveRecord::Migration
  def self.up
    rename_column :images, :file, :string, :null => false
  end

  def self.down
    rename_column :images, :url, :string, :null => false
	end
end
