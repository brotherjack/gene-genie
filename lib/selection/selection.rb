# frozen_string_literal: true

require_relative '../gene_genie'

module GeneGenie
  def self.normalize_hash(hash = {}, to = 2)
    total = Float hash.values.sum
    hash.each.each_with_object({}) do |(k, v), acc|
      acc[k] = (v / total).round(to)
    end
  end

  # Contains the various methods to generate offspring and select which
  # chromosomes persist to the next generation
  module Selection
    # An abstract class containing methods shared by all Selection methods
    class Method
      def cumulative_sum(summable)
        if summable.respond_to? :keys
          keys = summable.keys.slice(1..-1)
          sums = {}
          summable.slice(*keys).each.with_index do |(key, _value), index|
            sums[key] = summable.values.slice(index + 1..-1).sum
            sums
          end
          Hash[[[summable.keys.first, 1.0]] + sums.to_a]
        else
          sums = [1.0]
          (1..summable.length - 1).each do |index|
            sums << summable.slice(index..-1).sum
          end
          sums
        end
      end

      def normalize(population, to = 2)
        if population.is_a? GeneGenie::Population
          unless population.fitness_scores?
            raise 'Population does not have fitness scores'
          end

          population.normalize_fitness_scores(to)
        else
          indexed = population
                    .each.with_index
                    .each_with_object({}) do |(v, i), acc|
            acc[i] = v
          end
          GeneGenie.normalize_hash(indexed, to)
        end
      end
    end
  end
end
