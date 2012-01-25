class CreateBlogArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :blogger, polymorphic: true
      t.integer :comments_count, default: 0, null: false
      t.timestamps
    end
    add_index :articles, [:blogger_type, :blogger_id]
  end
end
