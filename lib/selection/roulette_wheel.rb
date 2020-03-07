require_relative 'selection'

module Genetic
  module Selection
    class RouletteWheel < Genetic::Selection::Method
      attr_reader :wheel, :population

      def initialize(population, to=2)
        @population = population
        @wheel = cumulative_sum normalize(population, to).sort.reverse
      end
    end
  end
end
