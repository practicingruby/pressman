require "uri" 
require "net/http" 
require "yaml"

module HttpToYaml
  class TooManyRedirects < StandardError; end

  BACKEND = 'http://192.168.200.105:4567'

  def get(uri, redirection_limit = 10)
    uri = URI.parse("#{BACKEND}#{uri}")
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get(uri.path, {'Accept' => 'text/yaml'})
    end
    handle_or_decode_response(response, :redirection_limit => redirection_limit)
  end

  def post(uri, params = {})
    uri = URI.parse("#{BACKEND}#{uri}")
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Post.new(uri.path)
      request['Accept'] = 'text/yaml'
      request.set_form_data(params)
      http.request(request)
    end
    handle_or_decode_response(response)
  end

  def put(uri, params = {})
    post uri, params.merge(:_method => 'put')    
  end

  def delete(uri, params = {})
    post uri, params.merge(:_method => 'delete')
  end

  def handle_or_decode_response(response, options = {})
    case response
    when Net::HTTPSuccess
      YAML.load(response.body)
    when Net::HTTPRedirection
      limit = options[:redirection_limit] || 10
      raise TooManyRedirects if limit == 1
      get response['Location'], limit - 1
    end
  end
end

Shoes.app :width => 520, :height => 605, :title => "Pressman" do
  
  extend HttpToYaml

  def cell_color
    @colors ||= [yellow, gray]
    @colors.unshift(@colors.pop).last
  end
  
  def toggle_cell(row, col)
    if @old_cell
      @board[@old_cell[:row]][@old_cell[:col]].style(:fill => @old_cell[:fill])
    end
    
    if @from
      response = post("/move", "from_col" => @from[:col], "from_row" => @from[:row],
                      "to_col"   => col,  "to_row" => row)
      
      if response == "ok"
        @from = nil
      else
        @from = { :row => row, :col => col }
      end
      
      update_pieces
    else
      @from = { :row => row, :col => col } if @pieces[[row, col]]
    end
    
    @old_cell = { :row => row, :col => col, :fill => @board[row][col].style[:fill] }
    @board[row][col].style(:fill => orange)
  end

  def build_board
    @board = (1..8).map { Array.new }
    8.times do |j|
      8.times do |k|
        fill cell_color
        @board[j][k] = rect :left => 20 + k*50, :top => 20 + 50*j, :width => 50, :height => 50 
        #fill black
        update_pieces
      end
      cell_color # HACKA
    end 
  end
  
  def update_pieces
    board = get("/board")
    
    @pieces ||= {}
    @pieces.each { |_,e| e.hide }
    @pieces.replace({}) #HACKA
    
    8.times do |j|
      8.times do |k|
        if piece = board[j][k]
          fill piece == :black ? black : white
          @pieces[[j,k]] = oval :left => 30 + k*50, :top => 30 + 50*j, :width => 30, :height => 30
        end
      end
    end
  end
  
  get "/new_game"
  
  # alert "Got it! #{(r - 20) / 50}, #{(c - 20) / 50}"
  click do |button, c, r|  
    update_pieces
    toggle_cell((r - 20) / 50, (c - 20) / 50)
  end

  background black
  stack :margin => "0 0 0 0" do
    fill rgb(0, 190, 0)
    build_board
  end
  
  animate(2) do
    update_pieces
  end

end
