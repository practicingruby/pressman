require "#{File.dirname(__FILE__)}/test_helper"

class TestBoard < Test::Unit::TestCase
  
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
  
  must "be able to determine the path to a point along a row" do
    actual_path = @board.path_from([5,1], :to => [5,5])
    assert_equal [[5,2],[5,3],[5,4],[5,5]], actual_path
    
    actual_path = @board.path_from([5,5], :to => [5,1])
    assert_equal [[5,4],[5,3],[5,2],[5,1]], actual_path
  end
  
  must "be able to determine the path to a point along a column" do
    actual_path = @board.path_from([1,5], :to => [5,5])
    assert_equal [[2,5],[3,5],[4,5],[5,5]], actual_path
    
    actual_path = @board.path_from([5,5], :to => [1,5])
    assert_equal [[4,5],[3,5],[2,5],[1,5]], actual_path
  end
  
  must "be able to determine the path to a point along a diagonal" do
    actual_path = @board.path_from([1,1], :to => [5,5])
    assert_equal [[2,2],[3,3],[4,4],[5,5]], actual_path
    
    actual_path = @board.path_from([5,1], :to => [1,5])
    assert_equal [[4,2],[3,3],[2,4],[1,5]], actual_path
  end
  
  must "raise an error when the path is invalid" do
    assert_raises(Pressman::InvalidPathError) do
      @board.path_from([4,1], :to => [1,5])
    end
  end  
  
  must "be able to save and restore a board" do
    @board.save_as("foo.data")
    assert_equal @board, Pressman::Board.load("foo.data")
  end
  
end