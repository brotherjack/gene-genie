# frozen_string_literal: true

module GeneGenie
  module Crossover
    # Performs a single point crossover on two parent chromosomes of equal
    # length.
    #
    # This process randomly selects a point (n) on the chromosome
    # creating two potential children: one with the first parent's genes up to
    # point n and the second parent's genes after that point, and vice-versa.
    #
    # TODO: probability of crossover
    class SinglePoint
      attr_reader :parents, :parents_length, :points, :probability_of_crossover

      def initialize(parents, probability_of_crossover = 0.5)
        confirm_only_two_parents parents
        confirm_parents_have_at_least_two_genes parents

        unless self.class.compatible? parents
          raise TypeError, 'Both chromosomes must have the same number of genes'
        end

        @parents_length = parents[0].genes.length
        @points = (1...parents_length).to_a
        @parents = parents
        @probability_of_crossover = probability_of_crossover
      end

      def recombine
        survivors = []
        children = make_children(select_point)

        2.times do |index|
          survivors << if rand <= @probability_of_crossover
                         children[index]
                       else
                         @parents[index]
                       end
        end

        survivors
      end

      def self.compatible?(parents)
        return true unless parents[0].genes.length != parents[1].genes.length
      end

      private

      def confirm_only_two_parents(parents)
        return if parents.length == 2

        raise ArgumentError, 'Can only have two parents'
      end

      def confirm_parents_have_at_least_two_genes(parents)
        return unless parents.any? { |parent| parent.genes.length < 2 }

        raise IndexError, 'Both parents must have at least two genes'
      end

      def make_children(point)
        raise IndexError if [0, @parents_length].include? point

        [
          splice_chromosome(@parents.first.genes, @parents.last.genes, point),
          splice_chromosome(@parents.last.genes, @parents.first.genes, point)
        ]
      end

      def select_point
        raise IndexError, 'No more points!' if @points.empty?

        point = @points.sample
        @points.delete_at @points.index(point)
      end

      def splice_chromosome(first_parent, second_parent, point)
        first_part = first_parent.slice(0...point)
        second_part = second_parent.slice(point...@parents_length)

        GeneGenie::Chromosome.new first_part + second_part
      end
    end
  end
end
