# coding: utf-8
require "tataki/base"

module Tataki
  EASY_CONVERTER = Tataki::Converter::Combine.new(
      Tataki::Converter::SkkJisyo.new,
      Tataki::Converter::Alphabet.new,
  ).freeze

  String.class_eval do
    def to_kana
      EASY_CONVERTER.to_kana(self)
    end
  end
end
