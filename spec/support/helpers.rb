module Helpers
  def create_population(array)
    population = Genetic::Population.new
    fitness_hash = array.each.inject({}) do |acc, f|
      acc[SecureRandom.uuid] = f
      acc
    end
    population.send('fitness_scores=', fitness_hash)
    population
  end
end
