require "#{File.dirname(__FILE__)}/test_helper"

class PressmanBoardTest < Test::Unit::TestCase
  
  setup do
    @board = Pressman::Board.new 
    @board[0,0] = :black
  end
  
  must "have 8 rows and 8 columns" do
    assert_equal [8,8], 
      [Pressman::Board::ROW_COUNT, Pressman::Board::COLUMN_COUNT]
  end
  
  must "be able to move a piece from one place on the board to another" do
    @board.move_from([0,0], :to => [1,0])
    
    assert_equal nil, @board[0,0]
    assert_equal :black, @board[1,0]
  end
  
  must "throw an error when moving to a row outside of the boundaries" do
    assert_raises(Pressman::PositionOutOfBoundsError) do
      @board.move_from([0,0], :to => [8,0])
    end
  end
  
  must "throw an error when moving to a column outside of the boundaries" do
    assert_raises(Pressman::PositionOutOfBoundsError) do
      @board.move_from([0,0], :to => [0,8])
    end
  end
  
  must "not allow a piece to be moved to the same position" do
    assert_raises(Pressman::IllegalMoveError) do
      @board.move_from([0,0], :to => [0,0])
    end
  end
  
  must "ensure a piece is at a position before moving it" do
    assert_raises(Pressman::IllegalMoveError) do
      @board.move_from([1,0], :to => [1,1])
    end
  end
  
end