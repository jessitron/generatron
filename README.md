# Generatron

The name is a tron-ification of "generative."

The objective is to have generators of random data that can be built up
from small to large.

I don't actually want to do the data generation; instead, use other
libraries (currently rantly) to do that. The point is to wrap that in a
class that lets you build in modifications.

This is roughly based on ScalaCheck generators, or would be if I ever
flesh it out.

## The talk

Generative Testing for Better Code, my presentation for Steel City Ruby
and Windy City Rails, 2014.

This is a demo library for that.

Here are some links to other things mentioned in the talk:

John Hughes' important paper: [Why Functional Programming Matters](http://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf)

The examples of tests around a web service:
[github.com/jessitron/venn](http://github.com/jessitron/venn)

The example of converting from an example test to a property test,
slowly (check the commit history for the evolution): [github.com/jessitron/gerald](http://github.com/jessitron/gerald)

The ScalaCheck version of this talk: [ScalaCheck with Prisoners
Dilemma](http://github.com/jessitron/scalacheck-prisoners-dilemma)

