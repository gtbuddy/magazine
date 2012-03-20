module Magazine
  class Article < ActiveRecord::Base

    require "acts-as-taggable-on"
    require "will_paginate"
    
    acts_as_taggable    

    before_save :set_first_image

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

    has_many :images, :class_name => "Magazine::Image"

    if Magazine.configuration.include_comments 
      has_many :comments, :class_name => "Magazine::Comment", :order => "created_at DESC"
    end

    # ==========
    # = Scopes =
    # ==========

    # Returns the blog articles paginated for the index page
    # @scope class
		
    scope :index_scope, lambda { order("created_at DESC") }
    scope :review, where(:needs_review => true)
    scope :public, where(:needs_review => false, :published => true)

    # ====================
    # = Instance Methods =
    # ====================
    
    accepts_nested_attributes_for :images, :allow_destroy => true

    def self.for_index(page_no)
      self.public.index_scope.paginate(:page => page_no)
    end

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
      update_attribute :date_published, published if published
    end

    def set_default_image(image_id)
      @images = self.images
      @default_image = @images.default_image.first
      @new_default_image = @images.find(image_id)
      unless @default_image == @new_default_image 
        @default_image.remove_default
        @new_default_image.set_default
      end
    end

    def cover_image
      @images = self.images
      @images.default_image.first
    end

    private
    def set_first_image
      self.images.first.update_attribute :is_default_image, true if self.images.count < 1
    end

  end
end
