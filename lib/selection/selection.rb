require_relative '../genetic'

module Genetic
  def self.normalize_array(array=[], to=2)
    total = Float array.sum
    array.each.inject([]) { |acc, el| acc << (el / total).round(to); acc }
  end

  def self.normalize_hash(hash={}, t=2)
    total = Float hash.values.sum
    # TODO: WHY 2 and not t=2 or to=2!?
    hash.each.inject({}) { |acc, (k,v)| acc.update({k => (v / total).round(2)}) }
  end

  module Selection
    class Method
      def normalize(population, to=2)
        if population.is_a? Genetic::Population
          raise 'Population does not have fitness scores' unless population.has_fitness_scores?
          population.normalize_fitness_scores(to)
        else
          return Genetic.normalize_array(population, to)
        end
      end
    end
  end
end
