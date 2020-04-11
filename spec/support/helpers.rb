require 'securerandom'

module Helpers
  def create_population_with_fitness_scores(array)
    population = GeneGenie::Population.new
    fitness = array.each.each_with_object({}) do |value, acc|
      acc[SecureRandom.uuid] = value
    end
    population.send('fitness_scores=', fitness)
    population
  end
end
