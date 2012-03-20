
module Magazine
  class Image < ActiveRecord::Base
    require 'carrierwave/orm/activerecord'

    attr_accessible :file, :name, :alt_name, :is_default_image

    belongs_to :article, :class_name => "Magazine::Article"

    before_save :assign_random_string

    mount_uploader :file, ProcessedArticleImage

    scope :default_image, where(:is_default_image => true)

    def filename
      ActiveSupport::SecureRandom.hex(10) + File.extname(@filename) if @filename
    end

    def set_default
      update_attribute :is_default_image, true
    end

    def remove_default
      update_attribute :is_default_image, false
    end

    private

    def assign_random_string
      self.random_string = ActiveSupport::SecureRandom.hex(10)
    end
  end
end
