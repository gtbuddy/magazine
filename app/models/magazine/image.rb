module Magazine
  class Image < ActiveRecord::Base

    attr_accessible :file

    belongs_to :article

    mount_uploader :file, ProcessedArticleImage
    
  end
end
