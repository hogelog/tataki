# coding: utf-8
require "yaml"
require "time"
require "skk/jisyo"
require "trie"

module Tataki
  module Converter
    class SkkJisyo < Base
      DEFAULT_CONFIG_PATH = "../../../../data/skk-jisyo.yml"
      DEFAULT_JISYO_SUFFIXES = %w[M]

      def initialize(jisyo_types = DEFAULT_JISYO_SUFFIXES)
        @jisyo_paths = jisyo_types.map{|suffix| Skk::Jisyo.path(suffix) }
        @trie_cache_path = trie_cache_path(jisyo_types.join("_"))

        config_file = File.expand_path(DEFAULT_CONFIG_PATH, __FILE__)
        config_data = YAML.load_file(config_file)
        @roman_data = config_data["roman_table"]
        @ignore_kana = config_data["ignore_kana"]
        @trie = setup_jisyo.freeze
      end

      def setup_jisyo
        if File.exist?(@trie_cache_path)
          trie = Marshal.load(File.read(@trie_cache_path))
        else
          trie = Trie.new
          @jisyo_paths.each do |jisyo_path|
            add_jisyo(trie, jisyo_path)
          end
          File.binwrite(@trie_cache_path, Marshal.dump(trie))
          File.write("#{@trie_cache_path}.timestamp", Time.now.to_s)
        end
        trie
      end

      def add_jisyo(trie, jisyo_path)
        File.open(jisyo_path, "rb:euc-jp") do |jisyo_file|
          jisyo_file.each_line do |line|
            next if line.empty? || line[0] == ";" || line.include?("#")
            kana, kanji_part = line.encode("utf-8").split(" ")
            next unless kana && kanji_part
            kana.gsub!(/[^ぁ-んa-z]/, "")
            next if kana.empty? || !(kana =~ /^[ぁ-ん]+[a-z]?/) || @ignore_kana.include?(kana)
            kanji_part.gsub!(/^\/|;.+|\/$/, "")
            kanji_part.split("/").each do |kanji|
              trie.insert(kanji, kana)
            end
          end
        end
      end

      def jisyo_path
        File.expand_path("../../../../data/jisyo", __FILE__)
      end

      def trie_cache_path(name)
        File.join(jisyo_path, "SKK-JISYO.#{name}.trie.cache")
      end

      def jisyo_timestamp(path)
        Time.parse(File.read("#{path}.timestamp"))
      end

      def to_kana(sentence)
        _to_kana(sentence, "", "", @trie)
      end

      private

      def _to_kana(sentence, kana, prefix, trie, through_alphabet = true)
        return if trie.empty?
        return kana if sentence.empty?

        next_ch = sentence[0]
        next_sentence = sentence[1..-1]
        next_trie = trie.find_prefix(next_ch)
        next_trie_values = next_trie.values
        next_trie_values.reject!{|value| value =~ /[a-z]/ }
        next_set = next_trie.find([])
        next_set_values = next_set.values
        okurigana = find_okurigana(next_set_values, next_sentence)
        next_set_values.reject!{|value| value =~ /[a-z]/ }
        if okurigana
          return _to_kana(next_sentence, kana + okurigana, "", @trie)
        elsif next_set_values.size > 0 && next_set_values.size == next_trie_values.size
          return _to_kana(next_sentence, kana + next_set_values.sample, "", @trie)
        end

        if next_sentence.empty?
          if next_set_values.size > 0
            return kana + next_set_values.sample
          elsif through_alphabet
            return kana + prefix + next_ch
          end
        end

        next_kana = _to_kana(next_sentence, kana, prefix + next_ch, next_trie, false)

        if next_kana
          return next_kana
        end

        if next_set_values.size > 0
          return _to_kana(next_sentence, kana + next_set_values.sample, "", @trie)
        elsif through_alphabet
          return _to_kana(next_sentence, kana + prefix + next_ch, "", @trie)
        else
          return nil
        end
      end

      def find_okurigana(yomi_candidates, next_sentence)
        yomi_candidates.each do |yomi|
          next unless yomi =~ /.+([a-z])$/
          okurigana_yomi = @roman_data[$1]
          next unless okurigana_yomi
          okurigana_yomi.each do |okurigana|
            return yomi.gsub(/[a-z]$/, "") if next_sentence.start_with?(okurigana)
          end
        end
        nil
      end
    end
  end

  Tataki::CONVERTERS << Converter::SkkJisyo
end
