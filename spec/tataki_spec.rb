# coding: utf-8
require "spec_helper"

describe Tataki do
  it "has a version number" do
    Tataki::VERSION.should_not be_nil
  end

  describe ".converters" do
    it "returns converters" do
      expect(Tataki.converters).to match_array([
        Tataki::Converter::Alphabet,
        Tataki::Converter::Combine,
        Tataki::Converter::SkkJisyo,
      ])
    end
  end

  describe "String.to_kana" do
    before { require "tataki" }

    it "converts to kana" do
      expect("X線研究者".to_kana).to eq("えっくすせんけんきゅうしゃ")
    end
  end
end
