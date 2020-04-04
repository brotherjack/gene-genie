require 'byebug'
module GeneGenie
  module Crossover
    class SinglePoint
      attr_reader :max_children, :points

      def recombine(parents, children=2, probability_of_crossover=0.5)
        raise ArgumentError, 'Can only have two parents' unless parents.length == 2

        if parents.any? { |parent| parent.genes.length < 2 }
          raise IndexError, 'Both parents must have at least two genes' 
        end

        @max_children = (parents[0].genes.length - 1) * 2
        unless children <= max_children
          raise RangeError, "Maximum number of children is #{max_children}"
        end

        unless compatible? parents
          raise TypeError, 'Both chromosomes must have the same number of genes'
        end

        @points = (1...parents[0].genes.length).to_a
      end

      private

      def compatible?(parents)
        return true unless parents[0].genes.length != parents[1].genes.length
      end

      def select_point
        raise IndexError, 'No more points!' if @points.length == 0
        point = @points.sample
        @points.delete_at @points.index(point)
      end
    end
  end
end
