# frozen_string_literal: true

require_relative 'gene_genie/version'
require 'securerandom'

# A Gem for developing Genetic Algorithms whose name is a pun on 1990's
# "Game Genie". Could be potentially used to make something to hack ROM's, but
# this is not the intent of the author.
module GeneGenie
  class Error < StandardError; end
  def self.humanize_large_number(number)
    number = number.to_s if number.respond_to? :to_s
    integer_part, decimal_part = number.split('.')

    integers = []
    (0..integer_part.length).each do |i|
      next if integer_part.reverse[i].nil?

      if integers.empty?
        integers << integer_part.reverse[i]
      elsif integers.last.length < 3
        integers[-1] = integers[-1] + integer_part.reverse[i]
      else
        integers << integer_part.reverse[i]
      end
    end
    integer_part = integers.join(',').reverse
    "#{integer_part}.#{decimal_part}"
  end

  # Represents a set of chromosomes
  # TODO: Set fixed size
  class Population
    attr_reader :fitness_scores

    def initialize(chromosomes = {})
      @population = setup_population_hash chromosomes
      @fitness_scores = {}
    end

    def add_chromosome(chromosome)
      population << chromosome
    end

    def at(id)
      population[id]
    end

    def fitness_scores?
      !fitness_scores.empty?
    end

    def normalize_fitness_scores(to = 2)
      @fitness_scores = GeneGenie.normalize_hash(fitness_scores, to)
    end

    def run_fitness(&fitness_function)
      @fitness_scores = population
                        .each_with_object({}) do |(id, chromosome), hash|
        hash[id] = chromosome.run_fitness(&fitness_function)
      end
    end

    def to_h
      population.each.inject({}) { |acc, el| acc.update(el.to_h) }
    end

    def to_s
      @population.to_s
    end

    private

    def setup_population_hash(chromosomes)
      return chromosomes if chromosomes.is_a? Hash

      unless chromosomes&.first.is_a?(Chromosome)
        raise 'Must be a hash or a GeneGenie::Chromosome'
      end

      chromosomes.each.inject({}) { |acc, ch| acc.update(ch.to_h) }
    end

    attr_accessor :population
    attr_writer :fitness_scores
  end

  # Represents a Chromosome - which in this context is an array of Gene objects
  # A chromosome automatically generates a secure random ID
  class Chromosome
    attr_reader :id, :genes

    def initialize(genes)
      @genes = genes
      @id = SecureRandom.uuid
    end

    def run_fitness(&function)
      function.call genes
    end

    def show
      repr = genes.each_with_object([]) { |gene, acc| acc << gene.show; }
      "Chromosome #{id} #{repr}"
    end

    def to_h
      { id => genes }
    end

    private

    attr_writer :genes
  end

  # Building blocks of genetic algorithms. Consists of a label called a `trait`
  # and a value
  class Gene
    def initialize(name, value = 0)
      @trait = name
      @value = value
    end

    def ===(other)
      other.send(:trait) == trait
    end

    def ==(other)
      (other.send(:trait) == @trait) && (other.send(:value) == @value)
    end

    def get_value_if_trait_is(kind, instead_of_nil = 0)
      if kind.is_a? Enumerable
        found = kind.each { |k| break value if k == trait }
        return found unless found.nil?
      elsif kind == trait
        kind == trait
      else
        instead_of_nil
      end
    end

    def show
      "#{trait}: #{value}"
    end

    private

    attr_accessor :trait, :value
  end

  if __FILE__ == $PROGRAM_NAME
    number_of_chromosomes = 10

    number_range = 1..100
    length_range = 0.0..10.0

    chromosomes = number_of_chromosomes.times.each_with_object({}) do |_, hash|
      chromosome = Chromosome.new([
                                    Gene.new(
                                      :number_of_blades, rand(number_range)
                                    ),
                                    Gene.new(
                                      :length_of_blades, rand(length_range)
                                    )
                                  ])
      hash[chromosome.id] = chromosome
    end

    population = Population.new chromosomes
    fitness_fn = lambda do |genes|
      genes.inject(0) do |acc, gene|
        gene = gene.get_value_if_trait_is(%i[number_of_blades length_of_blades])
        acc + gene * 12.3**Math::PI
      end
    end
    puts 'First generation fitness: '

    first_generation_fitness = population.run_fitness(&fitness_fn)
    first_generation_fitness.each.with_index do |(id, fitness), index|
      chromosome = population.at(id)
      puts "##{index + 1} - #{chromosome.show}"
      puts "fitness is #{GeneGenie.humanize_large_number(fitness)}"
    end
  end
end
