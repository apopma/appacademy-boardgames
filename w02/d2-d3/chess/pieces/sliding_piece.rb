require_relative '../piece'

class SlidingPiece < Piece
  def initialize(pos, board, color)
    super
  end

  def moves
    all_moves = []

    self.class::MOVE_DIFFS.each do |drow, dcol|
      row, col = pos
      new_pos = [row + drow, col + dcol]

      while move_on_board?(new_pos) && board[new_pos].empty?
        row, col = new_pos
        all_moves << new_pos if legal_move?(new_pos)     # for empty squares
        new_pos = [row + drow, col + dcol]
      end

      all_moves << new_pos if enemy?(new_pos) # for squares containing an enemy
    end

    all_moves
  end
end
