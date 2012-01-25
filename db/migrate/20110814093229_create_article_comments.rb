class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :article_comments do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :website
      t.text :body, :null => false
      t.references :article, :null => false
      t.string :state

      t.timestamps
    end
    add_index :article_comments, :article_id
  end
end
