module Blogit
  class Configuration
    
    # Should we include comments for blog articles?
    attr_accessor :include_comments

    # The name of the controller method we'll call to return the current blogger.
    attr_accessor :current_blogger_method
    
    # what method do we call on blogger to return their display name?
    # Defaults to :username
    attr_accessor :blogger_display_name_method
    
    # Which DateTime::FORMATS format do we use to display 
    # blog and comment publish time
    # Defaults to :short
    attr_accessor :datetime_format
    
    # Number of articles to show per page
    # @see https://github.com/amatsuda/kaminari
    # @see Blogit::Article
    attr_accessor :articles_per_page
    
    # Should text within "```" or "`" be highlighted as code?
    # Defaults to true
    # @note - At the moment this only works when default_parser
    #   is :markdown
    attr_accessor :highlight_code_syntax
    
    # The name of the before filter we'll call to authenticate the current user.
    # Defaults to :login_required
    attr_accessor :authentication_method
    
    # If set to true, only the user who authored the article may, edit or destroy.
    # Defaults to false
    attr_accessor :author_edits_only
    
    # If set to true, the comments form will POST and DELETE to the comments 
    # controller using AJAX calls.
    # Defaults to true
    attr_accessor :ajax_comments
    
    # If set to true, the create, edit, update and destroy actions
    # will be included. If set to false, you'll have to set these 
    # yourself elsewhere in the app
    attr_accessor :include_admin_actions
    
    # If set to true, links for new articles, editing articles and deleting comments
    # will be available. If set to false, you'll have to set these 
    # yourself in the templates.
    attr_accessor :include_admin_links
    
    # The default format for parsing the blog content.
    # Defaults to :markdown
    attr_accessor :default_parser
      
    # When using redcarpet as content parser, pass these options as defaults
    # Defaults to REDCARPET_OPTIONS
    attr_accessor :redcarpet_options  
    
    # Should the controllers cache the blog pages as HTML?
    # Defaults to false
    attr_accessor :cache_pages
    
    # The title of the RSS feed for the blog articles
    # Defaults to "[Application Name] Blog Articles"    
    attr_accessor :rss_feed_title
    
    # The description of the RSS feed for the blog articles
    # Defaults to "[Application Name] Blog Articles"
    attr_accessor :rss_feed_description

    # The default language of the RSS feed
    # Defaults to 'en'
    attr_accessor :rss_feed_language

    
    REDCARPET_OPTIONS = {
      "hard_wrap" => "true", 
      "filter_html" => "true", 
      "autolink" => "true",
      "no_intraemphasis" => "true",
      "fenced_code_blocks" => "true",
      "gh_blockcode" => "true",
    }
    
    def initialize
      @include_comments            = true
      @current_blogger_method      = :current_user
      @blogger_display_name_method = :username
      @datetime_format             = :short
      @articles_per_page              = 5
      @authentication_method       = :login_required
      @author_edits_only           = false
      @ajax_comments               = true
      @include_admin_actions       = true
      @include_admin_links         = true      
      @cache_pages                 = false
      @default_parser              = :markdown
      @highlight_code_syntax       = true
      @rss_feed_title              = "#{Rails.application.class.parent_name.titleize} Blog Articles"
      @rss_feed_description        = "#{Rails.application.class.parent_name.titleize} Blog Articles"
      @rss_feed_language           = "en"
      @redcarpet_options           = REDCARPET_OPTIONS
    end
    
    def default_parser_class
      "Blogit::Parsers::#{@default_parser.to_s.classify}Parser".constantize
    end
    
  end
end