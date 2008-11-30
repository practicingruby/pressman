require "yaml"

module Pressman
  class Board
    
    ROW_COUNT    = 8
    COLUMN_COUNT = 8
    
    def self.load(filename)
      Marshal.load(File.open(filename, "rb") { |f| f.read})
    end
    
    def initialize
      @data = (1..ROW_COUNT).map { Array.new(COLUMN_COUNT) }
    end
    
    attr_reader :data
    
    def []=(*args)
      row, col, value = args.flatten
      check_boundaries(row,col)
      @data[row][col] = value
    end
    
    def [](*args)
      row, col = args.flatten
      check_boundaries(row,col)
      @data[row][col]
    end
    
    def move_from(position, options={})
      check_move_legality(position, options[:to])
      self[options[:to]] = self[position]
      self[position] = nil
    end
    
    def occupied_at?(point)
      !! self[point]
    end
    
    def occupied_by?(color, options)
      self[options[:at]] && self[options[:at]].color == color
    end
    
    def path_from(origin, options)
      row1, col1 = origin
      row2, col2 = options[:to]
      
      if col1 == col2
        row1.to(row2).map { |e| [e, col1] }[1..-1]
      elsif row1 == row2
        col1.to(col2).map { |e| [row1, e] }[1..-1]
      elsif (row1-row2).abs == (col1-col2).abs
         row1.to(row2).zip(col1.to(col2)).map { |row,col| [row,col] }[1..-1]      
      else
         raise InvalidPathError
      end
    end
    
    def inspect
      output = "\n0 1 2 3 4 5 6 7\n"
      
      @data.each_with_index do |row, i|
        output << row.map { |e| e || "+" }.join(" ") + " #{i}\n"
      end
      
      return output
    end
    
    def save_as(filename)
      File.open(filename, "wb") { |f| f << Marshal.dump(self) }
    end
    
    def ==(other)
      @data == other.data
    end
    
    def to_yaml
      @data.map { |row| row.map { |e| e && e.color } }.to_yaml
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