require 'rantly/shrinks'

module Shrinkers

  class << self

    # chop an array around the first
    # item that satisfies the predicate.
    # returns [[all, false, items], true_item, [everything, else]]
    def split_around(arr, predicate)
      compl = ->(e) { not predicate.call(e)}
      after = arr.drop_while &compl
      before = arr.take_while &compl
      [before, after.first, after.drop(1)]
    end

    # monkeypatching!! to override what
    # rantly does to class Array. This array will never
    # shrink in size, it'll only shrink its elements.
    def fixed_len_array(a)
      def a.shrink
        (before, shrink_me, after) =
          Shrinkers.split_around(self, (lambda &:shrinkable?))
        next_smallest = before + [shrink_me.shrink] + after
        Shrinkers.fixed_len_array(next_smallest) #maintain this property
      end

      def a.shrinkable?
        any? &:shrinkable?
      end
      a
    end
  end

  #shrink an array of 2 inputs properly
  def self.shrink_like_i_say(r)
    def r.shrink
      #TODO: also shrink the second one
      if (first.shrinkable?)
        Shrinkers.shrink_like_i_say([first.shrink, last])
      else
        Shrinkers.shrink_like_i_say([first, last.shrink])
      end
    end

    def r.shrinkable?
      first.shrinkable? || last.shrinkable?
    end
    r
  end

  def self.do_not_shrink(r)
    def r.shrinkable?
      false
    end
    r
  end
end


