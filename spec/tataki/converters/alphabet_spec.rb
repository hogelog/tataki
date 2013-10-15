require "spec_helper"

describe Tataki::Converter::Alphabet do
  let(:converter) { Tataki::Converter::Alphabet.new }

  describe ".to_kana" do
    shared_examples "converts_kana" do |sentence, kana|
      it "converts #{sentence.inspect} to #{kana.inspect}" do
        expect(converter.to_kana(sentence)).to eq(kana)
      end
    end

    include_examples "converts_kana", "", ""
    include_examples "converts_kana", "hoge!", "えいちおーじーいー!"
  end
end
