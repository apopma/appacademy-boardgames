require_relative '../piece'

class SteppingPiece < Piece
  def initialize(pos, board, color)
    super
  end

  def moves
    all_moves = []
    row, col = pos

    self.class::MOVE_DIFFS.each do |drow, dcol|
      new_move = [row + drow, col + dcol]
      all_moves << new_move if legal_move?(new_move)
    end

    all_moves
  end
end
