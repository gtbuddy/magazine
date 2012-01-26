module Magazine
  module Blogs

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      # When called within a model (usually User) this creates
      # a has-many assosciation between the model and Magazine::Article
      def blogs
        has_many :articles, :as => "blogger", :class_name => "Magazine::Article"
      end
            
    end
    
  end
end