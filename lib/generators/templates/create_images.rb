class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :url, :null => false
      t.timestamps
    end
    add_index :images, :article_id
    add_column :articles, :excerpt, :text
  end

  def self.down
		drop_table :images
    remove_column :articles, :excerpt
	end
end
