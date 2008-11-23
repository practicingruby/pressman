module Pressman
  class Board
    
    def initialize
      @width  = 9
      @height = 9
    end
    
    attr_reader :width, :height
    
    def [](row,col)
      if row < 2
        Stone.new(:black)
      else
        Stone.new(:white)
      end
    end
    
  end
  
  class Stone
    def initialize(color)
      @color = color
    end
    
    attr_reader :color
  end
end