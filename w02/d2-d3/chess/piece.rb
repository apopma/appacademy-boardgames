require 'colorize'

class Piece
  attr_reader :color, :board, :id
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos = pos
    @color = color
    @board = board
    @id = ' '
  end

  def empty?
    false
  end

  def king?
    false
  end

  def to_s
    self.id.colorize(color)
  end

  def moves
    raise "moves not implemented"
  end

  def move_to(destination)
    self.pos = destination
  end

  def dup(duped_board)
    self.class.new(self.pos, duped_board, self.color)
  end

  def legal_move?(pos)
    move_on_board?(pos) && square_available?(pos)
  end

  def can_move_to?(pos)
    self.moves.include?(pos)
  end

  protected
  def move_on_board?(pos)
    pos.all? { |elem| elem.between?(0, 7) }
  end

  def square_available?(pos)
    board[pos].empty? || enemy?(pos)
  end

  def enemy?(pos)
    move_on_board?(pos) && board[pos].color != self.color && !board[pos].empty?
  end

  def rook_unmoved?
    false
  end
end
