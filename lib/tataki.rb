require "skk/jisyo"
require "tataki/version"
require "tataki/converters"

require "pry"

module Tataki
  module Converter
  end

  def self.converters
    CONVERTERS
  end
end
