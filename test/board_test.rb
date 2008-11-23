require "#{File.dirname(__FILE__)}/test_helper"

describe "A Pressman board" do
  
  setup { @board = Pressman::Board.new }
  
  must "have a size of 9x9" do
    assert [@board.width, @board.height], [9,9]
  end
  
  must "have a row major cell accessor" do
    assert Pressman::Stone === @board[0,0]
  end
  
  must "start with black cells in the first two rows" do
    [0,1].each do |ri|
      row = (0..8).map { |ci| @board[ri,ci] }
      assert row.length == 9
      assert row.all? { |e| e.color == :black }
    end
  end
  
  must "start with white cells in the last two rows" do
    [7,8].each do |ri|
      row = (0..8).map { |ci| @board[ri,ci] }
      assert row.length == 9
      assert row.all? { |e| e.color == :white }
    end
  end
  
end