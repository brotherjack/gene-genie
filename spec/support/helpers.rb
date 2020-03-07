require 'securerandom'

module Helpers
  def create_population_with_fitness_scores(array)
    population = Genetic::Population.new
    fitness = array.each.inject({}) do |acc, f|
      acc[SecureRandom.uuid] = f
      acc
    end
    population.send('fitness_scores=', fitness)
    population
  end
end
