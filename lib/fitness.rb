module GeneGenie
  class Fitness
    def initalize(&fn)
      @function = &fn
    end

    private
    attr_accessor :function
  end
end
