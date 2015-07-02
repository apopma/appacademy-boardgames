require_relative 'board'

class Piece
  attr_reader :color
  attr_accessor :pos, :board, :king

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color # one of :red or :black
    @king = false
  end

  def perform_slide

  end

  def perform_jump
  end

  def move_diffs
    diffs = regular_move_diffs
    diffs += king_move_diffs if king?
    diffs
  end

  def regular_move_diffs
    #red at top and moves down (+vely), black at bottom and moves -vely
    if color == :red
      [[1, 1], [1, -1]]
    else
      [[-1, 1], [-1, -1]]
    end
  end

  def king_move_diffs
    if color == :red
      [[-1, 1], [-1, -1]]
    else
      [[1, 1], [1, -1]]
    end
  end

  def king_me!
    @king = true
  end

  def empty?
    false
  end

  def king?
    king ? true : false
  end

end

# b = Board.new
# red_man = Piece.new([0, 3], b, :red)
# black_man = Piece.new([5, 4], b, :black)
#
# p "red ordinary diffs at #{red_man.pos}: #{red_man.move_diffs}"
# p "black ordinary diffs: #{black_man.move_diffs}"
#
# red_man.king_me!
# black_man.king_me!
#
# p "red royal diffs: #{red_man.move_diffs}"
# p "black royal diffs: #{black_man.move_diffs}"
