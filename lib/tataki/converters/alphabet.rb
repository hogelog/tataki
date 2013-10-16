# coding: utf-8
require "yaml"

module Tataki
  module Converter
    class Alphabet < Base
      def initialize
        alphabet_file = File.expand_path("../../../../data/alphabet.yml", __FILE__)
        alphabet_data = YAML.load_file(alphabet_file)
        @table = alphabet_data["table"]
      end

      def to_kana(sentence)
        kana = ""
        sentence.downcase.each_char do |ch|
          kana << (@table[ch] || ch)
        end
        kana
      end
    end
  end

  Tataki::CONVERTERS << Converter::Alphabet
end
