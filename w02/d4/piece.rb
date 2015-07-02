require 'colorize'

 MOVE_DIFFS = { :red => [[-1, 1], [1, -1]], :black => [[1, 1],  [-1, -1]] }
 JUMP_DIFFS = { :red => [[2, 2],  [2, -2]], :black => [[-2, 2], [-2, -2]] }

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

  def moves(type)
    raise ArgumentError unless [:sliding, :jumping].include?(type)
    row, col = location
    diffs = (type == :sliding) ? move_diffs : jump_diffs

    all_moves = diffs.map do |drow, dcol|
      new_move = [row + drow, col + dcol]
    end

    all_moves.select { |move| valid_move?(move) }
  end

  def move_to(destination)
    board.remove_piece(location)
    @location = destination #location is a local var without @ or self?
    board[destination] = self
  end

  def perform_slide(destination) #doesn't really need an origin?
    unless moves(:sliding).include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't move to #{destination}!"
    end

    move_to(destination)
  end

  def perform_jump(piece, destination)
    unless moves(:jumping).include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't jump to #{destination}!"
    end

    #gets the average of origin/destination poses, then refs Board at that pos
    between = piece.location.zip(destination).map { |row, col| (row + col) / 2 }
    between_piece = board[between]

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
    self.king? ? "#{color} king at #{location}" : "#{color} piece at #{location}"
  end
end

class IllegalMoveError < RuntimeError
end