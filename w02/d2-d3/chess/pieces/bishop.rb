require_relative 'sliding_piece'

class Bishop < SlidingPiece
  MOVE_DIFFS = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

  def initialize(pos, board, color)
    super
    @id = "♗"
  end
end
