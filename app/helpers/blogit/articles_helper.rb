module Blogit
  module ArticlesHelper
        
    # Creates a div tag with class 'article_' + name
    # Eg: 
    #   article_tag(:title, "") # => <div class="article_title"></div>
    def article_tag(name, content_or_options = {}, options ={}, &block)
      if block_given?
        content = capture(&block)
        options = content_or_options
      else
        content = content_or_options
      end
      options[:class] = "#{options[:class]} article_#{name}".strip
      content_tag(name, content, options)
    end
        
  end
end
