class AddDefaultImageToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :is_default_image, :boolean, :default => false
  end

  def self.down
    remove_column :images, :is_default_image
	end
end
