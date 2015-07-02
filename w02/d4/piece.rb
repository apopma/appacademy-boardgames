require_relative 'board'

 MOVE_DIFFS = {
   :red => [[1, 1], [1, -1]],
   :black => [[-1, 1], [-1, -1]]
 }

class Piece
  attr_reader :color
  attr_accessor :pos, :board, :king

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color # one of :red or :black
    @king = false
  end

  def perform_slide

  end

  def perform_jump
  end

  def move_diffs
    diffs = MOVE_DIFFS[color]
    diffs += MOVE_DIFFS[other_color] if king?
    diffs
  end

  def other_color
    color == :red ? :black : :red
  end

  def king_me!
    @king = true
  end

  def empty?
    false
  end

  def king?
    king ? true : false
  end

end

b = Board.new
red_man = Piece.new([0, 3], b, :red)
black_man = Piece.new([5, 4], b, :black)

p "red ordinary diffs at #{red_man.pos}: #{red_man.move_diffs}"
p "black ordinary diffs: #{black_man.move_diffs}"

red_man.king_me!
black_man.king_me!

p "red royal diffs: #{red_man.move_diffs}"
p "black royal diffs: #{black_man.move_diffs}"
