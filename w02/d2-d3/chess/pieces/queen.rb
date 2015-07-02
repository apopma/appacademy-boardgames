require_relative 'sliding_piece'

class Queen < SlidingPiece
  MOVE_DIFFS = [[1, 1], [1, -1], [-1, 1], [-1, -1],
                [0, 1], [0, -1], [1, 0], [-1, 0]]

  def initialize(pos, board, color)
    super
    @id = "♕"
  end
end
