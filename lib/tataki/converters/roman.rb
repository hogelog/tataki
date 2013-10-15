require "trie"
require "yaml"

module Tataki
  module Converter
    class Roman < Base
      SOKUON = "っ"

      def initialize
        @trie = Trie.new
        roman_file = File.expand_path("../../../../data/roman.yml", __FILE__)
        roman_data = YAML.load_file(roman_file)
        roman_data["table"].each do |roman, kana|
          @trie.insert(roman, kana)
        end
        @consonant = roman_data["consonant"]
        @trie.freeze
      end

      def to_kana(sentence)
        _to_kana(sentence.downcase, "", "", @trie)
      end

      private

      def _to_kana(sentence, kana, prefix, trie, through_alphabet = true)
        return if trie.empty?
        return kana if sentence.empty?

        next_ch = sentence[0]
        next_sentence = sentence[1..-1]
        next_trie = trie.find_prefix(next_ch)
        next_set = next_trie.find([])
        if next_set.size > 0 && next_set.size == next_trie.size
          return _to_kana(next_sentence, kana + next_set.values.first, "", @trie)
        end

        if next_sentence.empty?
          if next_set.size > 0
            return kana + prefix + next_set.values.first
          else
            return kana + prefix + next_ch
          end
        end

        next_kana = _to_kana(next_sentence, kana, prefix + next_ch, next_trie, false)

        if next_kana
          return next_kana
        end

        if next_set.size > 0
          return _to_kana(next_sentence, kana + next_set.values.first, "", @trie)
        elsif next_sentence.start_with?(next_ch)
          return _to_kana(next_sentence, kana + SOKUON, "", @trie)
        elsif through_alphabet
          return _to_kana(next_sentence, kana + prefix + next_ch, "", @trie)
        else
          return nil
        end
      end
    end
  end

  Tataki::CONVERTERS << Converter::Roman
end
