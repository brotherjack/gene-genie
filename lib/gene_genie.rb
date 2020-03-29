require_relative "gene_genie/version"
require 'securerandom'

module GeneGenie
  class Error < StandardError; end
  def self.humanize_large_number(number)
    number = number.to_s if number.respond_to? :to_s
    integer_part, decimal_part = number.split('.')

    integers = []
    for i in 0..integer_part.length
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

  class Population
    attr_reader :fitness_scores

    def initialize(chromosomes={})
      unless chromosomes.is_a? Hash
        if chromosomes&.first.is_a? Chromosome
          chromosomes = chromosomes.each.inject({}) { |acc, ch| acc.update(ch.to_h) }
        else
          raise "Must be a hash or a GeneGenie::Chromosome" 
        end
      end
      @population = chromosomes
      @fitness_scores = {}
    end

    def add_chromosome(chromosome)
      population << chromosome
    end

    def at(id)
      population[id]
    end

    def has_fitness_scores?
      !fitness_scores.empty?
    end

    def normalize_fitness_scores(to=2)
      @fitness_scores = GeneGenie.normalize_hash(fitness_scores, to)
    end

    def run_fitness(&fn)
      @fitness_scores = population.inject({}) do |hash, (id, chromosome)|
        hash[id] = chromosome.run_fitness &fn
        hash
      end
    end

    def to_h
      population.each.inject({}) { |acc, el| acc.update(el.to_h) }
    end

    def to_s
      @population.to_s
    end

    private
    attr_accessor :population
    attr_writer :fitness_scores
  end

  class Chromosome
    attr_reader :id, :genes

    def initialize(genes)
      @genes = genes
      @id = SecureRandom.uuid
    end

    def run_fitness(&fn)
      fn.call genes
    end

    def show
      repr = genes.inject([]) { |acc, gene| acc << gene.show; acc }
      "Chromosome #{id} #{repr}"
    end

    def to_h
      {id => genes}
    end

    private
    attr_writer :genes
  end

  class Gene
    def initialize(name, value=0)
      @trait = name
      @value = value
    end

    def ===(other)
      return other.send(:trait) == trait
    end

    def ==(other)
      return (other.send(:trait) == @trait) && (other.send(:value) == @value)
    end

    def get_value_if_trait_is(kind, instead_of_nil=0)
      if kind.is_a? Enumerable
        found = kind.each { |k| break value if k == trait }
        return found unless found.nil?
      else
        return value if kind == trait
      end
      instead_of_nil
    end

    def show
      "#{trait}: #{value}"
    end

    private
    attr_accessor :trait, :value
  end

  if __FILE__ == $0
    number_of_chromosomes = 10
    number_of_genes = 2

    number_range = 1..100
    length_range = 0.0..10.0

    chromosomes = number_of_chromosomes.times.inject({}) do |hash, _|
      chromosome = Chromosome.new([
        Gene.new(:number_of_blades, rand(number_range)),
        Gene.new(:length_of_blades, rand(length_range))
      ])
      hash[chromosome.id] = chromosome
      hash
    end

    population = Population.new chromosomes
    fitness_fn = lambda do |genes|
      genes.inject(0) do |acc, gene|
        acc + gene.get_value_if_trait_is([:number_of_blades, :length_of_blades]) * 12.3 ** Math::PI
      end
    end
    puts "First generation fitness: "

    first_generation_fitness = population.run_fitness &fitness_fn
    first_generation_fitness.each.with_index do |(id, fitness), index|
      chromosome = population.at(id)
      puts "##{index+1} - #{chromosome.show}"
      puts "fitness is #{GeneGenie.humanize_large_number(fitness)}"
    end
  end
end
