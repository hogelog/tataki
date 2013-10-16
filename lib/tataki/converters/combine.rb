# coding: utf-8
module Tataki
  module Converter
    class Combine < Base
      def initialize(*converters)
        @converters = converters
      end

      def to_kana(sentence)
        kana = sentence
        @converters.each do |converter|
          kana = converter.to_kana(kana)
        end
        kana
      end
    end
  end

  Tataki::CONVERTERS << Converter::Combine
end
