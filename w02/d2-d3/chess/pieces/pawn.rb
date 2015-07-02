require_relative '../piece'

class Pawn < Piece
  attr_reader :board, :color
  attr_accessor :pos, :moved

  def initialize(pos, board, color, moved = false)
    super(pos, board, color)
    @moved = moved
    @id = "♙"
  end

  def move_to(destination)
    super
    @moved = true
  end

  def moves
    capture_moves + normal_moves
  end

  def capture_moves
    moveset = capture_diffs

    all_moves = []
    row, col = pos

    moveset.each do |drow, dcol|
      new_pos = [row + drow, col + dcol]
      all_moves << new_pos if enemy?(new_pos)
    end

    all_moves
  end

  def normal_moves
    all_moves = []
    row, col = pos

    moveset = normal_move_diffs
    moveset.concat(first_move_diffs) unless @moved

    moveset.each do |drow, dcol|
      new_pos = [row + drow, col + dcol]
      if board[new_pos].empty? && move_on_board?(new_pos)
        all_moves << new_pos
      end
    end

    all_moves
  end

  def normal_move_diffs
    color == :black ? [[1, 0]] : [[-1, 0]]
  end

  def first_move_diffs
    color == :black ? [[2, 0]] : [[-2, 0]]
  end

  def capture_diffs
    color == :black ? [[1, 1], [1, -1]] : [[-1, 1], [-1, -1]]
  end

  def dup(duped_board)
    Pawn.new(pos, duped_board, color, moved)
  end
end
