require "#{File.dirname(__FILE__)}/test_helper"

class TestStone < Test::Unit::TestCase
  setup do
    @board = Pressman::Board.new
    @stone = Pressman::Stone.new(:black, :board    => @board,
                                         :position => [3,3] ) 
  end
  
  must "have a color" do
    assert_equal :black, @stone.color
  end
  
  must "have a default status of active" do
    assert_equal :active, @stone.status
  end
  
  must "be able to deactivate" do
    @stone.deactivate
    assert_equal :inactive, @stone.status
  end
  
  must "be able to activate" do
    @stone.activate
    assert_equal :active, @stone.status
  end
  
  must "have a position" do
    assert_equal [3,3], @stone.position
  end
  
  [[3,4],[4,3],[2,3],[3,2],[2,2],[2,4],[4,2],[4,4]].each do |pos|  
    must "be able to move to an adjacent empty square #{pos}" do
      @stone.move_to(pos)
      assert_equal pos, @stone.position
    end
    
    must "not be able to move on top of a stone of the same color at #{pos}" do
      occupied = Pressman::Stone.new(:black, :board    => @board,
                                             :position => pos )
      
      assert_raises(Pressman::IllegalMoveError) do
        @stone.move_to(pos)
      end
    end  
  end
  
  must "not be able to move through a stone of the same color" do
    friend = Pressman::Stone.new(:black, :board    => @board,
                                         :position => [3,5] )
    assert_raises(Pressman::IllegalMoveError) do
      @stone.move_to([3,6])
    end
  end
  
  must "not be able to move through a stone of another color" do
    enemy = Pressman::Stone.new(:white, :board    => @board,
                                         :position => [3,5] )
    assert_raises(Pressman::IllegalMoveError) do
      @stone.move_to([3,6])
    end
  end
  
  must "be able to replace a stone of another color" do
    enemy = Pressman::Stone.new(:white, :board    => @board,
                                         :position => [3,5] )
    assert_nothing_raised do
      @stone.move_to([3,5])
    end
  end

end