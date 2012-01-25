module Blogit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path('../../templates', __FILE__)

      desc "Creates a Blogit initializer in your application's config/initializers dir"

      def copy_initializer
        template "blogit.rb", "config/initializers/blogit.rb"
      end

		  include Rails::Generators::Migration

		  def self.next_migration_number(dirname)
		    if ActiveRecord::Base.timestamped_migrations
					milliseconds = Time.now
					"%10.6f" % milliseconds.to_f
					milliseconds = milliseconds.usec
		      t = Time.new.utc.strftime("%Y%m%d%H%M%S")
					t = t.to_s + milliseconds.to_s
		    else
		      "%.3d" % (current_migration_number(dirname) + 1)
		    end
		  end

		  def create_migration_file
		    migration_template 'create_articles.rb', 'db/migrate/create_articles.rb'
		    migration_template 'create_article_comments.rb', 'db/migrate/create_article_comments.rb'
		  end
		end
  end
end