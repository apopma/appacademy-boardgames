require_relative 'stepping_piece'

class Knight < SteppingPiece
  MOVE_DIFFS = [[1, 2], [1, -2], [-1, 2], [-1, -2],
                [2, 1], [2, -1], [-2, 1], [-2, -1]]

  def initialize(pos, board, color)
    super
    @id = "♘"
  end
end
