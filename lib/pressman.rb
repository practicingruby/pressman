module Pressman
  
  class PositionOutOfBoundsError < StandardError; end
  class IllegalMoveError < StandardError; end
  
  class Board
    
    ROW_COUNT    = 8
    COLUMN_COUNT = 8
    
    def initialize
      @data = (1..ROW_COUNT).map { Array.new(COLUMN_COUNT) }
    end
    
    def []=(row,col,value)
      check_boundaries(row,col)
      @data[row][col] = value
    end
    
    def [](row,col)
      check_boundaries(row,col)
      @data[row][col]
    end
    
    def move_from(position, options={})
      check_move_legality(position, options[:to])
      self[*options[:to]] = self[*position]
      self[*position] = nil
    end
    
    private
    
    def check_boundaries(row, col)
      if row > ROW_COUNT - 1 || col > COLUMN_COUNT - 1
        raise PositionOutOfBoundsError 
      end
    end
    
    def check_move_legality(from, to)
      raise IllegalMoveError if from == to || self[*from].nil?
    end
      
  end
end