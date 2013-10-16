# coding: utf-8
module Tataki
  CONVERTERS = []

  module Converter
    class Base
      def to_kana(sentence)
        raise "TODO: implement .to_kana"
      end
    end
  end
end

Dir[File.expand_path("../converters", __FILE__) + "/*.rb"].each do |file|
  require file
end
