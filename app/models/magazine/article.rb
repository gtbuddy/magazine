module Magazine
  class Article < ActiveRecord::Base

    require "acts-as-taggable-on"
    require "will_paginate"
    
    acts_as_taggable    

    self.table_name = "articles"

    self.per_page = Magazine.configuration.articles_per_page

    # ===============
    # = Validations =
    # ===============

    validates :title, :presence => true, :length => { :minimum => 5, :maximum => 66 }
    validates :body,  :presence => true, :length => { :minimum => 5 }
    validates :blogger_id, :presence => true

    # =================
    # = Assosciations =
    # =================    

    belongs_to :blogger, :polymorphic => true

    if Magazine.configuration.include_comments 
      has_many :comments, :class_name => "Magazine::Comment"
    end

    # ==========
    # = Scopes =
    # ==========

    # Returns the blog articles paginated for the index page
    # @scope class
		
    scope :for_index, lambda { |page_no| order("created_at DESC").paginate(:page => page_no) }
    scope :review, where(:needs_review => true)
    scope :public, where(:needs_review => false, :published => true)

    # ====================
    # = Instance Methods =
    # ====================

    def to_param
      "#{id}-#{title.parameterize}"
    end

    # If there's a current blogger and the display name method is set, returns the blogger's display name
    # Otherwise, returns an empty string
    def blogger_display_name
      if self.blogger and !self.blogger.respond_to?(Magazine.configuration.blogger_display_name_method)
        raise ConfigurationError, 
        "#{self.blogger.class}##{Magazine.configuration.blogger_display_name_method} is not defined"
      elsif self.blogger.nil?
        ""
      else
        self.blogger.send Magazine.configuration.blogger_display_name_method        
      end
    end

    #Toggles the article's featured field
    def toggle_feature
      update_attribute :featured, !featured
    end

    #Approves an article pending of review
    def approve
      update_attribute :needs_review, false
    end

    #Toggles the article's published field
    def toggle_publish
      update_attribute :published, !published
    end

  end
end
