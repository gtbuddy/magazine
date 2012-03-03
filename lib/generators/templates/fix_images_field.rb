class FixImagesField < ActiveRecord::Migration
  def self.up
    rename_column :images, :file, :string
  end

  def self.down
    rename_column :images, :url, :string
	end
end
