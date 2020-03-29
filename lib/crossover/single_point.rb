require 'byebug'
module GeneGenie
  module Crossover
    class SinglePoint
      def recombine(parents, children=2)
        raise ArgumentError, 'Can only have two parents' unless parents.length == 2

        if parents.any? { |parent| parent.genes.length < 2 }
          raise IndexError, 'Both parents must have at least two genes' 
        end

        max_children = (parents[0].genes.length - 1) * 2
        unless children <= max_children
          raise RangeError, "Maximum number of children is #{max_children}"
        end


      end

      private

      def compatible?(parents)
        return true unless parents[0].genes.length != parents[1].genes.length
      end

      def select_point
        raise NotImplementedError
      end
    end
  end
end
