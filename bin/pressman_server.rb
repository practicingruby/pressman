require "rubygems"
require "sinatra"
$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require "pressman"

get "/new_game" do
  
  board = Pressman::Board.new
  (0..1).each do |row|
    (0..7).each do |col|
      Pressman::Stone.new(:black, :position => [row,col], :board => board)
    end
  end
  
  (6..7).each do |row|
    (0..7).each do |col|
      Pressman::Stone.new(:white, :position => [row,col], :board => board)
    end
  end
  
  board.save_as("my_board.data")
  "Welcome"
end

get "/board" do
  send_data Pressman::Board.load("my_board.data").to_yaml, :type => "text/yaml"
end

post "/move" do
  begin
    board = Pressman::Board.load("my_board.data")
    from = [params["from_row"], params["from_col"]].map { |e| Integer(e) }
    to   = [params["to_row"], params["to_col"]].map { |e| Integer(e) }
    board[from].move_to(to)
    board.save_as("my_board.data")
    "ok"
  rescue
    "fail"
  end
end