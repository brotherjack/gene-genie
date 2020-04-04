module GeneGenie
  module Crossover
    class SinglePoint
      attr_reader :points

      def recombine(parents, probability_of_crossover=0.5)
        raise ArgumentError, 'Can only have two parents' unless parents.length == 2

        if parents.any? { |parent| parent.genes.length < 2 }
          raise IndexError, 'Both parents must have at least two genes' 
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
