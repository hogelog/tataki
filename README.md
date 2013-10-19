# Tataki

Tataki is pure ruby kana converter.

## Installation

Add this line to your application's Gemfile:

    gem 'tataki'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tataki

## Usage

### Basic usage
```ruby
require "tataki"

"漢字をひらがなに変換".to_kana # => "かんじをひらがなにへんかん"
"X線研究者".to_kana # => "えっくすせんけんきゅうしゃ"
"肉を食べるだけの簡単なお仕事".to_kana # => "にくをたべるだけのかんたんなおしごと"
```

At first time, `require "tataki"` is slow (creating dictionary cache).

### Configure converter
```ruby
require "tataki/base"

alphabet_converter = Tataki::Converter::Alphabet.new
alphabet_converter.to_kana("abcde") # => "えーびーしーでぃーいー"

skk_converter = Tataki::Converter::SkkJisyo.new
skk_converter.to_kana("研究者") # => "けんきゅうしゃ"

alphabet_skk_converter = Tataki::Converter::Combine.new(Tataki::Converter::Alphabet.new, Tataki::Converter::SkkJisyo.new)
alphabet_skk_converter.to_kana("X線研究者") # => "えっくすせんけんきゅうしゃ"

```

## TODO
- Support more configurable

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
