require 'colorize'

 MOVE_DIFFS = {
   :red => [[1, 1], [1, -1]],
   :black => [[-1, 1], [-1, -1]]
 }

class Piece
  attr_reader :color, :id
  attr_accessor :pos, :board, :king

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color # either :red or :black
    @king = false
    @id = "●"
  end

  def move_diffs
    diffs = MOVE_DIFFS[color]
    diffs += MOVE_DIFFS[other_color] if king?
    diffs
  end

  def moves
    row, col = pos
    all_moves = []

    move_diffs.each do |diff|
      drow, dcol = diff
      new_move = [row + drow, col + dcol]
      all_moves << new_move if valid_move?(new_move)
    end

    all_moves
  end

  def perform_slide
  end

  def perform_jump
  end

  def valid_move?(pos)
    move_on_board?(pos) && board[pos].empty?
  end

  def move_on_board?(pos)
    pos.all? { |elem| elem.between?(0, 7) }
  end

  def other_color
    color == :red ? :black : :red
  end

  def king_me!
    @king = true
    @id = '◉'
  end

  def empty?
    false
  end

  def king?
    king ? true : false
  end

  def to_s
    id.colorize(color)
  end
end


# b = Board.new
# rp = Piece.new([0, 1], b, :red)
# bp = Piece.new([5, 2], b, :black)
#
# p "#{rp.pos} moves to #{rp.moves}"
# p "#{bp.pos} moves to #{bp.moves}"
#
# rp.king_me!
# bp.king_me!
#
# puts "kings:"
# p "#{rp.pos} moves to #{rp.moves}"
# p "#{bp.pos} moves to #{bp.moves}"
