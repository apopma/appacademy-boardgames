require_relative 'empty_square'
require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
  end

  def setup
    setup_odd_row(0, :red)
    setup_even_row(1, :red)
    setup_odd_row(2, :red)

    setup_even_row(5, :black)
    setup_odd_row(6, :black)
    setup_even_row(7, :black)
  end

  def remove_piece(pos)
    self[pos] = EmptySquare.new
  end

  def render
    system("clear")
    grid.each_with_index do |row, ridx|
      row.each_with_index do |elem, cidx|
        print_elem(elem, ridx, cidx)
      end
      puts
    end
  end

  def print_elem(elem, ridx, cidx)
    #copied over from chess
    square = " #{elem.to_s} "

    if (ridx + cidx) % 2 == 0
      print square.on_light_red
    else
      print square.on_light_black
    end
  end

  def dup
    duped_board = Board.new

    grid.each_with_index do |row, ridx|
      row.each_with_index do |square, cidx|
        duped_pos = [ridx, cidx]
        duped_board[duped_pos] = square.dup(duped_board)
      end
    end

    duped_board
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  private
  def setup_odd_row(row, color)
    cols = [1, 3, 5, 7]
    cols.each { |col| grid[row][col] = Piece.new([row, col], self, color) }
  end

  def setup_even_row(row, color)
    cols = [0, 2, 4, 6]
    cols.each { |col| grid[row][col] = Piece.new([row, col], self, color) }
  end
end

b = Board.new
b1 = Piece.new([7, 0], b, :black)
r1 = Piece.new([6, 1], b, :red)
r2 = Piece.new([4, 3], b, :red)
r3 = Piece.new([2, 5], b, :red)

b[[7, 0]] = b1
b[[6, 1]] = r1
b[[4, 3]] = r2
b[[2, 5]] = r3
b.render

sleep(0.5)
b1.perform_moves([5, 2], [3, 4], [1, 6])
b.render
