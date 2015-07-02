require_relative 'board'

class Piece
  attr_accessor :pos, :king

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
    @king = false
  end

  def perform_slide

  end

  def perform_jump
  end

  def move_diffs
    regular_moves + king_move_diffs
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
