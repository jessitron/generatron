require 'rantly'
require_relative 'shrinkers'

class Generator
  def initialize(how_to_produce, description="stuff")
    @produce = how_to_produce
    @description = description
  end

  def not_shrinkable
    Generator.new(->() { Shrinkers.do_not_shrink(sample)})
  end

  def sample
    @produce.call
  end

  def sample_n(n)
    (1..n).map{ |x| sample}
  end

  def map(f)
    inner = self
    Generator.new(->() {f.call(inner.sample)})
  end

  def flat_map(f)
    inner = self
    Generator.new(->() { f.call(inner.sample).sample })
  end

  def filter(predicate)
    inner = self
    Generator.new -> do
      r = nil
      begin
        r = inner.sample
      end until predicate.(r)
      # consider using rantly.guard instead of looping
      r
    end
  end

  def inspect
    "Generator of " + @description
  end

  attr_accessor :description
end


module Generators
  class << self

    def of_two(gen1, gen2)
      Generator.new( ->() {
        r = [gen1.sample, gen2.sample]
        Shrinkers.shrink_like_i_say(r)
      })
    end

    def of(*args)
      Generator.new( ->() {
        Shrinkers.fixed_len_array(args.map(&:sample))
      }, args.map(&:description).join("+"))
    end

    def time(no_later_than=Time.now)
      pos_int.map(->(i) { no_later_than - i })
    end

    def any_number_of(inner, max=100)
      Generator.new( ->() {
        inner.sample_n(some_array_len(max).sample)
      })
    end

    def const(value)
      Generator.new(->{value})
    end

    def some_array_len(max=100)
      # this won't work with max < 2
      # I want this to emphasize smaller numbers. maybe later.

      Generator.new( ->() {
        rantly.freq([10, ->(r) {0}],
                    [10, ->(r) {1}],
                    [5,  ->(r) {2}],
                    [75, ->(r) {r.range(0,max)} ])} )
    end

    def rantly; Rantly.singleton end

    @@rantly = Rantly.singleton
    @@integer = Generator.new(->() { @@rantly.integer(1000000) }, "ints up to a million")
    @@string = Generator.new(->() { @@rantly.string(:print)}, "printable characters")

    def pos_int
      Generator.new(->() { @@rantly.positive_integer }, "positive ints up to a LOT")
    end

    def some_generator
      Generator.new( ->() {
        rantly.choose(@@integer, @@string)
      })
    end

    class Thing
    end
    # Return unique objects never equal to each other
    def things
      Generator.new(->() {
        Thing.new
      })
    end
  end
end
