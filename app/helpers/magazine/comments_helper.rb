module Magazine
  module CommentsHelper
    
    # Creates a div tag with class 'article_comment_' + name
    # Eg: 
    #   article_comment_tag(:email, "") # => <div class="article_comment_email"></div>
    def article_comment_tag(name, content_or_options = {}, options ={}, &block)
      if block_given?
        content = capture(&block)
        options = content_or_options
      else
        content = content_or_options
      end
      options[:class] = "#{options[:class]} article_comment_#{name}".strip
      content_tag(name, content, options)
    end

  end
end
