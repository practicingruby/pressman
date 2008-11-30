require "rubygems"
require "sinatra"
$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
require "pressman"
require "pstore"

helpers do
  def store(key=nil, val=nil)
    @store ||= PStore.new("game.data")
    if val
      @store.transaction { @store[key] = val }
    elsif key
      @store.transaction { @store[key] }
    else
      @store
    end
  end
end

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
  
  store(:board, board)
  store(:move, 0)
  "Welcome"
end

get "/board" do
  send_data store(:board).to_yaml, :type => "text/yaml"
end

get "/move_number" do
  send_data store(:move).to_yaml, :type => "text/yaml"
end

post "/move" do
  begin
    board = store.transaction { store[:board] }
    from = [params["from_row"], params["from_col"]].map { |e| Integer(e) }
    to   = [params["to_row"], params["to_col"]].map { |e| Integer(e) }
    board[from].move_to(to)
    store(:board, board)
    store(:move, store(:move) + 1)
    "ok"
  rescue
    "fail"
  end
end