require_relative 'empty_square'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
  end

end

b = Board.new
p b.grid.flatten.size
