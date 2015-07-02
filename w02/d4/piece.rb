require 'colorize'

 MOVE_DIFFS = {
   :red => [[-1, 1], [1, -1]],
   :black => [[1, 1], [-1, -1]]
 }

class Piece
  attr_reader :color, :id
  attr_accessor :pos, :board, :king

  def initialize(pos, board, color)
    @pos = pos
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

  def moves
    row, col = pos
    all_moves = []

    move_diffs.each do |diff|
      drow, dcol = diff
      new_move = [row + drow, col + dcol]
      puts
      p "possible new move #{new_move}"
      all_moves << new_move if valid_move?(new_move)
    end

    all_moves
  end

  def perform_slide(destination)
    puts "moving #{self.color} from #{self.pos} to #{destination}..."
    puts "possible moves #{moves}"
    raise IllegalMoveError unless moves.include?(destination)
    board.remove_piece(pos)
    self.pos = destination
    board[destination] = self
  end

  def perform_jump
  end

  def valid_move?(pos)
    p "#{pos} on board? #{move_on_board?(pos)}"
    p "#{board[pos]} is: #{board[pos].inspect}"
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
      "#{color} king at #{pos}"
    else
      "#{color} piece at #{pos}"
    end
  end
end

class IllegalMoveError < RuntimeError
end


# rp = Piece.new([0, 1], b, :red)
# bp = Piece.new([5, 2], b, :black)
#
# p "#{rp.pos} moves to #{rp.moves}"
# p "#{bp.pos} moves to #{bp.moves}"
#
# rp.king_me!
# bp.king_me!
#
# puts "kings:"
# p "#{rp.pos} moves to #{rp.moves}"
# p "#{bp.pos} moves to #{bp.moves}"
