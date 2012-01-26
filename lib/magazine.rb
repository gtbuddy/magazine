# Third-party requirements
require "acts-as-taggable-on"
require "will_paginate"
require "redcarpet"

require "magazine/configuration"
require "magazine/blogs"
require "magazine/engine"
require "magazine/parsers"

require "validators"
module Magazine
  
  autoload :ActsAsTaggableOn, "acts-as-taggable-on"
  autoload :WillPaginate, "will_paginate"
  
  # Exception raised when gem may not be configured properly
  class ConfigurationError < StandardError;end
  
  # Set global configuration options for Magazine
  # @see README.md
  def self.configure(&block)
    block.call(configuration)
  end
  
  # Returns Magazine's globalconfiguration. Will initialize a new instance
  # if not already set
  def self.configuration
    @configuration ||= Configuration.new
  end

end
