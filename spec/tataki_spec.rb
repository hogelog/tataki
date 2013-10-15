require "spec_helper"

describe Tataki do
  it "has a version number" do
    Tataki::VERSION.should_not be_nil
  end

  shared_examples "converts_to_kana" do |words, kana|
    let(:tataki) { Tataki::Converter.new }

    it "converts to kana" do
      p words, kana
      expect(tataki.to_kana(words)).to eq(kana)
    end
  end

  describe ".converters" do
    it "returns converters" do
      expect(Tataki.converters).to match_array([
        Tataki::Converter::Roman,
      ])
    end
  end

  describe "String.to_kana" do
    it { expect("robottotaisennf".to_kana).to eq("ろぼっとたいせんえふ") }
  end
end
