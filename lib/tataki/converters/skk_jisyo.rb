# coding: utf-8
require "yaml"
require "time"
require "skk/jisyo"

module Tataki
  module Converter
    class SkkJisyo < Base
      DEFAULT_CONFIG_PATH = "../../../../data/skk-jisyo.yml"
      DEFAULT_JISYO_SUFFIXES = %w[M]

      def initialize(jisyo_types = DEFAULT_JISYO_SUFFIXES)
        @jisyo_paths = jisyo_types.map{|suffix| Skk::Jisyo.path(suffix) }
        @table_cache_path = table_cache_path(jisyo_types.join("_"))

        config_file = File.expand_path(DEFAULT_CONFIG_PATH, __FILE__)
        config_data = YAML.load_file(config_file)
        @roman_data = config_data["roman_table"]
        @ignore_kana = config_data["ignore_kana"]
        tables = setup_jisyo
        @match_table = tables[0].freeze
        @okurigana_table = tables[1].freeze
      end

      def setup_jisyo
        if File.exist?(@table_cache_path)
          tables = Marshal.load(File.read(@table_cache_path))
        else
          match_table = {}
          okurigana_table = {}
          @jisyo_paths.each do |jisyo_path|
            add_jisyo(match_table, okurigana_table, jisyo_path)
          end
          tables = [match_table, okurigana_table]
          File.binwrite(@table_cache_path, Marshal.dump(tables))
          File.write("#{@table_cache_path}.timestamp", Time.now.to_s)
        end
        tables
      end

      def add_jisyo(match_table, okurigana_table, jisyo_path)
        File.open(jisyo_path, "rb:euc-jp") do |jisyo_file|
          jisyo_file.each_line do |line|
            next if line.empty? || line[0] == ";" || line.include?("#")
            kana, kanji_part = line.encode("utf-8").split(" ")
            next unless kana && kanji_part
            kana.gsub!(/[^ぁ-んa-z]/, "")
            next if kana.empty? || !(kana =~ /^[ぁ-ん]+[a-z]?/) || @ignore_kana.include?(kana)
            kanji_part.gsub!(/^\/|;.+|\/$/, "")

            table = kana =~ /^(.+)([a-z])$/ ? okurigana_table : match_table
            kanji_part.split("/").each do |kanji|
              kanji_prefix = kanji[0]
              table_entry = table[kanji_prefix]
              table[kanji_prefix] = table_entry = [] unless table_entry
              table_entry.push($2 ? [kanji, $1, $2] : [kanji, kana])
              table_entry.sort_by!{|entry| - (entry[0].size) }
            end
          end
        end
      end

      def jisyo_path
        File.expand_path("../../../../data/jisyo", __FILE__)
      end

      def table_cache_path(name)
        File.join(jisyo_path, "SKK-JISYO.#{name}.table.cache")
      end

      def jisyo_timestamp(path)
        Time.parse(File.read("#{path}.timestamp"))
      end

      def to_kana(sentence)
        _to_kana(sentence, "")
      end

      private

      def _to_kana(sentence, kana)
        return kana if sentence.empty?

        table_entry = find_okurigana_entry(sentence) || find_match_entry(sentence)
        if table_entry
          next_kanji = table_entry[0]
          next_kana = table_entry[1]
          next_sentence = sentence[next_kanji.size .. -1]
          return _to_kana(next_sentence, kana + next_kana)
        end

        return _to_kana(sentence[1 .. -1], kana + sentence[0])
      end

      def find_okurigana_entry(sentence)
        entries = @okurigana_table[sentence[0]]
        return unless entries

        entries.each do |entry|
          kanji, yomi, alphabet = *entry
          next unless sentence.start_with?(kanji)
          next_ch = sentence[kanji.size]
          okurigana_candidates = @roman_data[alphabet]
          next unless okurigana_candidates
          okurigana_candidates.each do |okurigana|
            return entry if okurigana == next_ch
          end
        end
        nil
      end

      def find_match_entry(sentence)
        entries = @match_table[sentence[0]]
        return unless entries

        entries.each do |entry|
          kanji, yomi = *entry
          return entry if sentence.start_with?(kanji)
        end
        nil
      end
    end
  end

  Tataki::CONVERTERS << Converter::SkkJisyo
end
