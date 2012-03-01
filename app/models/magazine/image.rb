module Magazine
  class Image < ActiveRecord::Base

    mount_uploader :processed_image, ProcessedImage
    
  end
end
