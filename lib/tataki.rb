require "skk/jisyo"
require "tataki/version"
require "tataki/converters"

require "pry"

module Tataki
  module Converter
    def initialize
      #@converters = converters.map {|converter| converter.new }
    end
  end

  def self.converters
    CONVERTERS
  end
end
