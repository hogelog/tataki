require "skk/jisyo"
require "tataki/version"
require "tataki/converters"

module Tataki
  module Converter
  end

  def self.converters
    CONVERTERS
  end

  def self.converter
    Tataki::Converter::Combine.new(
      Tataki::Converter::Roman.new,
      Tataki::Converter::Alphabet.new,
    )
  end
end
