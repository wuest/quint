require 'benchmark'

class QuintDemo
  def initialize(x)
    @x = x
  end

  def +(y)
    @x + y
  end
end

Benchmark.bm do |x|
  x.report { 1_000_000.times { foo = QuintDemo.new(1); _ = foo + 1 } }
end
