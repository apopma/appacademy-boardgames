require 'colorize'

 MOVE_DIFFS = {
   :red => [[-1, 1], [1, -1]],
   :black => [[1, 1], [-1, -1]]
 }

 JUMP_DIFFS = {
   :red => [[2, 2], [2, -2]],
   :black => [[-2, 2], [-2, -2]]
 }

class Piece
  attr_reader :color, :id
  attr_accessor :location, :board, :king

  def initialize(location, board, color)
    @location = location
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

  def jump_diffs
    diffs = JUMP_DIFFS[color]
    diffs += JUMP_DIFFS[other_color] if king?
    diffs
  end

  def moves
    row, col = location
    all_moves = []

    move_diffs.each do |diff|
      drow, dcol = diff
      new_move = [row + drow, col + dcol]
      all_moves << new_move if valid_move?(new_move)
    end

    all_moves
  end

  def jumps
    row, col = location
    all_jumps = []

    jump_diffs.each do |diff|
      drow, dcol = diff
      new_move = [(row + drow), (col + dcol)]
      all_jumps << new_move if valid_move?(new_move)
    end

    all_jumps
  end

  def move_to(destination)
    board.remove_piece(location)
    @location = destination #local var without the self?
    board[destination] = self
  end

  def perform_slide(destination) #doesn't really need an origin?
    unless moves.include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't move to #{destination}!"
    end

    move_to(destination)
  end

  def perform_jump(piece, destination)
    unless jumps.include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't jump to #{destination}!"
    end

    orow, ocol = location
    drow, dcol = destination
    row_diff = (drow - orow) - 1
    col_diff = (dcol - ocol) - 1
    between_piece = board[[(drow - row_diff), (dcol - col_diff)]]

    move_to(destination)
    board.remove_piece(between_piece.location)
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

  def inspect
     if self.king?
       "#{color} king at #{location}"
     else
       "#{color} piece at #{location}"
     end
  end
end

class IllegalMoveError < RuntimeError
end
