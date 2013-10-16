# coding: utf-8
require "spec_helper"

describe Tataki::Converter::Roman do
  let(:converter) { Tataki::Converter::Roman.new }

  describe ".to_kana" do
    shared_examples "converts_kana" do |sentence, kana|
      it "converts #{sentence.inspect} to #{kana.inspect}" do
        expect(converter.to_kana(sentence)).to eq(kana)
      end
    end

    include_examples "converts_kana", "", ""
    include_examples "converts_kana", "hoge", "ほげ"
    include_examples "converts_kana", "hogelog", "ほげぉg"
    include_examples "converts_kana", "hogge", "ほっげ"
    include_examples "converts_kana", "hogs", "ほgs"
    include_examples "converts_kana", "nanka", "なんか"
    include_examples "converts_kana", "nannnan", "なんなん"
    include_examples "converts_kana", "nannnann", "なんなん"
    include_examples "converts_kana", "nannnannsei", "なんなんせい"
    include_examples "converts_kana", "kukkingu", "くっきんぐ"
    include_examples "converts_kana", "kukkingu papa", "くっきんぐ ぱぱ"
    include_examples "converts_kana", "toukyoutokkyokyokakyoku", "とうきょうとっきょきょかきょく"

    include_examples "converts_kana", "kku", "っく"
    include_examples "converts_kana", ",,", ",,"
  end
end
