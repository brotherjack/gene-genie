module GeneGenie
  module Crossover
    class SinglePoint
      attr_reader :parents, :parents_length, :points, :probability_of_crossover

      def initialize(parents, probability_of_crossover = 0.5)
        unless parents.length == 2
          raise ArgumentError, 'Can only have two parents'
        end

        if parents.any? { |parent| parent.genes.length < 2 }
          raise IndexError, 'Both parents must have at least two genes'
        end

        unless self.class.compatible? parents
          raise TypeError, 'Both chromosomes must have the same number of genes'
        end

        @parents_length = parents[0].genes.length
        @points = (1...parents_length).to_a
        @parents = parents
        @probability_of_crossover = probability_of_crossover
      end

      def recombine
        make_children(select_point)
      end

      private

      def make_children(point)
        raise IndexError if point == 0 || point == @parents_length

        [
          splice_chromosome(@parents.first.genes, @parents.last.genes, point),
          splice_chromosome(@parents.last.genes, @parents.first.genes, point)
        ]
      end

      def select_point
        raise IndexError, 'No more points!' if @points.length == 0

        point = @points.sample
        @points.delete_at @points.index(point)
      end

      def splice_chromosome(first_parent, second_parent, point)
        first_part = first_parent.slice(0..point)
        second_part = second_parent.slice(point..@parents_length)

        GeneGenie::Chromosome.new first_part + second_part
      end

      def self.compatible?(parents)
        return true unless parents[0].genes.length != parents[1].genes.length
      end
    end
  end
end
