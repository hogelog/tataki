require "benchmark"

N = 1000

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tataki/base'
converter = Tataki::Converter::SkkJisyo.new(%w[M jinmei])

source = "かな漢字変換" * 100

puts Benchmark::CAPTION
puts Benchmark.measure {
  N.times do
    converter.to_kana(source)
  end
}
