module Magazine
  
  # This is a universal cache sweeper. If a comment is added or a 
  # blog article is updated, we should remove all the cached pages.
  # This will reduce the risk of dead links from tags clouds etc.
  #
  # To activate page caching, set <tt>config.cache_pages = true</tt>
  # in your magazine.rb file
  class MagazineSweeper < ActionController::Caching::Sweeper

    observe Magazine::Article, Magazine::Comment
    
    def after_save(record)
      clear_cached_pages
    end

    private

    def clear_cached_pages
      # remove each blog page (tags may require updating etc.)
      Magazine::Article.all.each do |article|
        expire_page article_path(article)
      end
      # remove the index blog pages
      expire_page "/blog"
      expire_page "/"
      expire_page "/blog/articles.xml"
      expire_page "/blog/articles.rss"
    end

  end
  
end