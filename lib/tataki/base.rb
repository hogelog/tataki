# coding: utf-8
require "skk/jisyo"
require "tataki/version"
require "tataki/converters"

module Tataki
  module Converter
  end

  def self.converters
    CONVERTERS
  end
end
