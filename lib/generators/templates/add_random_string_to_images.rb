class AddRandomStringToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :random_string, :string
  end

  def self.down
    remove_column :images, :random_string
	end
end
