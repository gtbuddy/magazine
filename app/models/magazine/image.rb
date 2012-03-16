
module Magazine
  class Image < ActiveRecord::Base
    require 'carrierwave/orm/activerecord'

    attr_accessible :file, :name, :alt_name

    belongs_to :article, :class_name => "Magazine::Article"

    before_save :assign_random_string

    mount_uploader :file, ProcessedArticleImage

    def filename
      ActiveSupport::SecureRandom.hex(10) + File.extname(@filename) if @filename
    end

    private

    def assign_random_string
      self.random_string = ActiveSupport::SecureRandom.hex(10)
    end
  end
end
