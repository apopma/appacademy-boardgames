require_relative 'empty_square'
require_relative 'piece'

class Board
  attr_accessor :grid, :cursor_pos, :selected_pos, :moves_at_selection

  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor_pos= [5, 4]
    @selected_pos = nil
    @moves_at_selection = []
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

    if cursor_pos == [ridx, cidx]
      print square.on_green
    elsif selected_pos == [ridx, cidx]
      print square.on_magenta
    elsif moves_at_selection.include?([ridx, cidx])
      print square.on_yellow
    elsif (ridx + cidx) % 2 == 0
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

  def reset_selection
    @selected_pos = nil
    @moves_at_selection = []
  end

  def select_pos(players_color)
    if self[cursor_pos].color == players_color
      @selected_pos = cursor_pos
      @moves_at_selection = self[cursor_pos].moves
    end
  end

  def move_cursor(diff)
    drow, dcol = diff
    row, col = cursor_pos

    new_pos = [row + drow, col + dcol]
    self.cursor_pos = new_pos if self.move_on_board?(new_pos)
  end

  def move_on_board?(pos)
    pos.all? { |elem| elem.between?(0, 7) }
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
