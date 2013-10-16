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

"robotto".to_kana # => "ろぼっと"
"robottotaisennf".to_kana # => "ろぼっとたいせんえふ"
```

### Configure converter
```ruby
require "tataki/base"

alphabet_converter = Tataki::Converter::Alphabet.new
alphabet_converter.to_kana("abcde") # => "えーびーしーでぃーいー"

combine_converter = Tataki::Converter::Combine.new(Tataki::Converter::Roman.new, Tataki::Converter::Alphabet.new)
combine_converter.to_kana("robottotaisennf") # => "ろぼっとたいせんえふ"
```

## TODO
- Add skk-jisyo converter

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
