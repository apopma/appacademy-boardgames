require 'colorize'

 MOVE_DIFFS = {
   :red => [[-1, 1], [1, -1]],
   :black => [[1, 1], [-1, -1]]
 }

 JUMP_DIFFS = {
   :red => [[-2, 2], [2, -2]],
   :black => [[2, 2], [-2, -2]]
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

  def jump_diffs
    diffs = JUMP_DIFFS[color]
    diffs += JUMP_DIFFS[other_color] if king?
    diffs
  end

  def moves
    row, col = pos
    all_moves = []

    move_diffs.each do |diff|
      drow, dcol = diff
      new_move = [row + drow, col + dcol]
      all_moves << new_move if valid_move?(new_move)
    end

    all_moves
  end

  def jumps
    row, col = pos
    all_jumps = []

    jump_diffs.each do |diff|
      drow, dcol = diff
      new_move = [row + drow, col + dcol]

      puts
      all_jumps << new_move if valid_move?(new_move)
    end
  end

  def perform_slide(destination) #doesn't really need an origin?
    unless moves.include?(destination)
      raise IllegalMoveError, "#{self.inspect} can't move to #{destination}!"
    end

    board.remove_piece(pos)
    self.pos = destination
    board[destination] = self
  end

  def perform_jump(origin, destination)
    orow, ocol = origin.pos
    drow, dcol = destination

    row_diff = (drow - orow) - 1
    col_diff = (dcol - ocol) - 1
    between_piece = board[[(drow - row_diff), (dcol - col_diff)]]

    p "#{origin.inspect} jumping to #{destination}"
    p "dest - origin: [#{drow - orow}, #{dcol - ocol}]"
    p "origin - dest: [#{orow - drow}, #{ocol - dcol}]"
    p "between diffs are [#{row_diff}, #{col_diff}]"
    p "between piece should be #{between_piece.inspect}"
    puts


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
    self.king? ? "#{color} king at #{pos}" : "#{color} piece at #{pos}"
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
