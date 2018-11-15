require 'quint'

Quint.warn!
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

module QuintMod
  include Quint

  sig(Integer, Integer, Integer)
  def self.add_3(a, b, c)
    a + b + c
  end
end

foo = QuintDemo.new(1)
_ = foo + 1


foo = QuintDemo.new('string')

_ = QuintMod.add_3(1, 2, 3.0)

foo = QuintDemo.new(1)

puts "Crash expected here (warn mode allowed us to get here at all)"
_ = foo + 'string'

