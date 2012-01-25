module Blogit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path('../../templates', __FILE__)

      desc "Creates a Blogit initializer in your application's config/initializers dir"

      def copy_initializer
        template "blogit.rb", "config/initializers/blogit.rb"
      end

    end

		class BlogGenerator < Rails::Generators::Base
		  include Rails::Generators::Migration
		  def self.source_root
		    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
		  end

		  def self.next_migration_number(dirname)
		    if ActiveRecord::Base.timestamped_migrations
		      Time.new.utc.strftime("%Y%m%d%H%M%S")
		    else
		      "%.3d" % (current_migration_number(dirname) + 1)
		    end
		  end

		  def create_migration_file
		    migration_template 'create_magazine_posts.rb', 'db/migrate/create_magazine_posts.rb'
		    migration_template 'create_magazine_comments.rb', 'db/migrate/create_magazine_comments.rb'
		  end
		end
  end
end