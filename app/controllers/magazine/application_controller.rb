module Magazine

  # Inherits from the application's controller instead of ActionController::Base
  class ApplicationController < ::ApplicationController
    # layout "magazine"
    helper :all
    helper 'magazine/application'

    helper_method :current_blogger, :magazine_conf
    
    # Sets a class method to specify a before-filter calling
    # whatever Magazine.configuration.authentication_method is set to
    # Accepts the usual before_filter optionss
    def self.magazine_authenticate(options ={})
      before_filter magazine_conf.authentication_method, options
    end

    # Sets a class method to specify a before-filter calling
    # whatever Magazine.configuration.admin_authenticated_method is set to
    # Accepts the usual before_filter optionss
    def self.magazine_authenticate_admin(options ={})
      before_filter magazine_conf.admin_authenticated_method, options
    end
    
    # A helper method to access the Magazine::configuration
    # at the class level
    def self.magazine_conf
      Magazine::configuration
    end
    
    # Turns on page caching for the given actions if 
    # Magazine.configuration.cache_pages is true
    def self.magazine_cacher(*args)
      if magazine_conf.cache_pages
        caches_page *args
      end
    end

    # Sets a cache sweeper to observe changes if 
    # Magazine.configuration.cache_pages is true
    def self.magazine_sweeper(*args)
      if magazine_conf.cache_pages
        cache_sweeper Magazine::MagazineSweeper, :only => args
      end
    end
    
    # A helper method to access the Magazine::configuration
    # at the controller instance level
    def magazine_conf
      self.class.magazine_conf
    end
    
    # Returns the currently logged in blogger by calling
    # whatever Magazine.current_blogger_method is set to
    def current_blogger
      send magazine_conf.current_blogger_method
    end
    
    # Returns true if the current_blogger is the owner of the article
    # @param article An instance of Magazine::Article
    def this_blogger?(article)
      current_blogger == article.blogger
    end
    
  end
end
