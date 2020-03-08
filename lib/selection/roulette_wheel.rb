require_relative 'selection'

module Genetic
  module Selection
    class RouletteWheel < Genetic::Selection::Method
      attr_reader :wheel, :population

      def initialize(population, to=2)
        @population = population
        if @population.respond_to? :fitness_scores
          normalized_scores = normalize(population, to)
          @wheel = cumulative_sum Hash[normalized_scores.sort_by { |_k, v| -v }]
        else
          normalized = normalize(population, to)
          @wheel = cumulative_sum Hash[normalized.sort_by { |_k, v| -v }]
        end
      end
    end
  end
end
