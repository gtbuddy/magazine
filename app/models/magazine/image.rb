module Magazine
  class Image < ActiveRecord::Base

    belongs_to :article

    mount_uploader :processed_image, ProcessedImage
    
  end
end
