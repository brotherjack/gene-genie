require_relative 'selection'

module Genetic
  module Selection
    def self.cumulative_sum(array)
      sum = [1.0]
      (1..array.length-1).each { |index| sum << array.slice(index..-1).sum }
      sum
    end

    class RouletteWheel < Genetic::Selection::Method
      attr_reader :wheel

      def initialize(population, to=2)
        normalized_and_sorted = normalize(population, to).sort.reverse
        @wheel = Genetic::Selection.cumulative_sum normalized_and_sorted
      end
    end
  end
end
