module Pressman
  class Stone
    
    def initialize(color, options)
      @color  = color
      @status = :active
      @board  = options[:board]
      
      @board[*options[:position]] = self 
      @position = options[:position]
    end
    
    def deactivate
      @status = :inactive
    end
    
    def activate
      @status = :active
    end
    
    def move_to(destination)
      path = @board.path_from(@position, :to => destination)
      
      path[0..-2].each do |point|
        raise IllegalMoveError if @board.occupied_at?(point)
      end
      
      if @board.occupied_by?(@color, :at => destination)
        raise IllegalMoveError
      end

      @board.move_from(@position, :to => destination)
      @position = destination
    end
    
    def to_s
      @color == :black ? "B" : "W"
    end
    
    attr_reader :color, :status, :position
  end
end