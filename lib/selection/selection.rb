require_relative '../genetic'

module Genetic
  def self.normalize_hash(hash={}, to=2)
    total = Float hash.values.sum
    hash.each.inject({}) do |acc, (k,v)|
      acc[k] = (v / total).round(to)
      acc
    end
  end

  module Selection
    class Method
      def cumulative_sum(summable)
        if summable.respond_to? :keys
          keys = summable.keys.slice(1..-1)
          sums = {}
          summable.slice(*keys).each.with_index do |(key, value), index|
            sums[key] = summable.values.slice(index+1..-1).sum
            sums
          end
          return Hash[[[summable.keys.first, 1.0]] + sums.to_a]
        else
          sums = [1.0]
          (1..summable.length-1).each do |index|
            sums << summable.slice(index..-1).sum
          end
          return sums
        end
      end

      def normalize(population, to=2)
        if population.is_a? Genetic::Population
          raise 'Population does not have fitness scores' unless population.has_fitness_scores?
          population.normalize_fitness_scores(to)
        else
          indexed = population.each.with_index.inject({}) do |acc, (v, i)|
            acc[i] = v
            acc
          end
          return Genetic.normalize_hash(indexed, to)
        end
      end
    end
  end
end
