# coding: utf-8
require "yaml"
require "time"
require "skk/jisyo"

module Tataki
  module Converter
    class SkkJisyo < Base
      def initialize
        @trie = setup_jisyo
      end

      def setup_jisyo
        if File.exist?(jisyo_trie_path)
          trie = Marshal.load(File.read(jisyo_trie_path))
        else
          trie = Trie.new
          Skk::Jisyo.paths.each do |jisyo_path|
            add_jisyo(trie, jisyo_path)
          end
          File.binwrite(jisyo_trie_path, Marshal.dump(trie))
          File.write("#{jisyo_trie_path}.timestamp", Time.now.to_s)
        end
        trie
      end

      def add_jisyo(trie, jisyo_path)
        File.open(jisyo_path, "rb:euc-jp") do |jisyo_file|
          jisyo_file.each_line do |line|
            next if line.empty? || line[0] == ";" || line.include?("#")
            kana, kanji_part = line.encode("utf-8").split(" ")
            next unless kana && kanji_part
            kana.gsub!(/[^ぁ-ん]/, "")
            next if kana.empty?
            kanji_part.gsub!(/^\/|;.+|\/$/, "")
            kanji_part.split("/").each do |kanji|
              trie.insert(kana, kanji)
            end
          end
        end
      end

      def jisyo_path
        File.expand_path("../../../../data/jisyo", __FILE__)
      end

      def jisyo_trie_path
        File.join(jisyo_path, "SKK-JISYO.trie.cache")
      end

      def jisyo_timestamp(path)
        Time.parse(File.read("#{path}.timestamp"))
      end

      def to_kana(sentence)
        sentence
      end
    end
  end

  Tataki::CONVERTERS << Converter::SkkJisyo
end
