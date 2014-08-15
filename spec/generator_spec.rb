require_relative 'spec_helper'

describe Generators do
  # This is necessary because Rantly requires random input
  # to be passed in exactly one parameter.
  # So we put multiple generated values in an array.
  # BUT Rantly's shrinking will cause the array to be shortened,
  # which is completely invalid. So fix the shrinking.
  it "Can group generators together" do
    property_of {
      Generators.any_number_of(Generators.some_generator,2).filter(->(e) {not e.empty?}).sample
    }.check do |lotsa_generators|
      unless lotsa_generators.size < 1
        gen = Generators.of(*lotsa_generators)
        result = gen.sample
        expect(result.size).to eq(lotsa_generators.size)
        expect(result).to be_shrinkable if result.any?(&:shrinkable?)
        shrunken = result # mutable
        while (shrunken.shrinkable?) do
          shrunken = shrunken.shrink
          expect(shrunken.size).to eq(lotsa_generators.size)
        end
      end
    end

  end
end
