# coding: utf-8
require "spec_helper"

describe Tataki::Converter::SkkJisyo do
  let(:converter) { Tataki::Converter::SkkJisyo.new }

  describe ".to_kana" do
    shared_examples "converts_kana" do |sentence, kana|
      it "converts #{sentence.inspect} to #{kana.inspect}" do
        expect(converter.to_kana(sentence)).to eq(kana)
      end
    end

    include_examples "converts_kana", "", ""
    #include_examples "converts_kana", "漢字", "かんじ"
  end
end
