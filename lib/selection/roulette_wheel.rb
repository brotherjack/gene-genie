# frozen_string_literal: true

require_relative 'selection'

module GeneGenie
  module Selection
    # A simple selection algorithm that mimics the operation of a roulette wheel
    class RouletteWheel < GeneGenie::Selection::Method
      attr_reader :wheel, :population

      def initialize(population, to = 2)
        @population = population
        if @population.respond_to? :fitness_scores
          normalized_scores = normalize(population, to)
          @wheel = cumulative_sum Hash[normalized_scores.sort_by { |_k, v| -v }]
        else
          normalized = normalize(population, to)
          @wheel = cumulative_sum Hash[normalized.sort_by { |_k, v| -v }]
        end
      end

      def select
        selection = generate_random
        @wheel.to_a.reverse.find { |item, bin| break item if selection <= bin }
      end

      private

      def generate_random
        rand 0.0..1.0
      end
    end
  end
end
