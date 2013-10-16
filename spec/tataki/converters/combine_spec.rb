# coding: utf-8
require "spec_helper"

describe Tataki::Converter::Combine do
  let(:roman_converter) { Tataki::Converter::Roman.new }
  let(:alphabet_converter) { Tataki::Converter::Alphabet.new }

  describe ".to_kana" do
    shared_examples "converts_kana" do |sentence, kana|
      it "converts #{sentence.inspect} to #{kana.inspect}" do
        expect(converter.to_kana(sentence)).to eq(kana)
      end
    end

    context "when roman + alphabet" do
      let(:converter) do
        Tataki::Converter::Combine.new(roman_converter, alphabet_converter)
      end

      include_examples "converts_kana", "robottotaisennf", "ろぼっとたいせんえふ"
    end
  end
end
