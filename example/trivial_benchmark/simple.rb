require 'benchmark'
require 'quint'

Quint.enable!
class QuintDemo
  include Quint

  sig(Integer, Object)
  def initialize(x)
    @x = x
  end

  sig(Integer, Integer)
  def +(y)
    @x + y
  end
end

Benchmark.bm do |x|
  x.report { 1_000_000.times { foo = QuintDemo.new(1); _ = foo + 1 } }
end
