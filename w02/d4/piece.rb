require 'colorize'

 MOVE_DIFFS = { :red => [[1, 1], [1, -1]], :black => [[-1, 1],  [-1, -1]] }
 JUMP_DIFFS = { :red => [[2, 2],  [2, -2]], :black => [[-2, 2], [-2, -2]] }

class Piece
  attr_reader :color, :id
  attr_accessor :location, :board, :king

  def initialize(location, board, color, king = false)
    @location = location
    @board = board
    @color = color # either :red or :black
    @king = king
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

  def perform_slide(destination)
    unless moves(:sliding).include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't move to #{destination}!"
    end

    move_to(destination)
  end

  def perform_jump(destination)
    #gets the average of origin/destination poses, then refs Board at that pos
    between = location.zip(destination).map { |row, col| (row + col) / 2 }
    between_piece = board[between]

    unless moves(:jumping).include?(destination) && enemy?(between_piece)
      raise IllegalMoveError, "\n#{self.inspect} can't jump to #{destination}!"
    end

    move_to(destination)
    board.remove_piece(between_piece.location)
  end

  def perform_moves!(*move_seq)
    #move seq is an array of destination pos
    p "performing #{move_seq}..."
    duped_board = board.dup
    duped_piece = duped_board[location]
    p "#{self.inspect} should == #{duped_piece.inspect}"

    until move_seq.empty?
      current_move = move_seq.shift
      p "Current move: #{current_move}"
      p "Location: #{duped_piece.location}"
      p "Piece to move: #{duped_piece.inspect}"
      p "Possible slides: #{duped_piece.moves(:sliding)}"
      p "Possible jumps: #{duped_piece.moves(:jumping)}"

      if duped_piece.moves(:sliding).include?(current_move)
        p "sliding to #{current_move}"
        duped_piece.perform_slide(current_move)
        break
      elsif duped_piece.moves(:jumping).include?(current_move)
        p "jumping to #{current_move}"
        duped_piece.perform_jump(current_move)
      else
        raise IllegalMoveError, "orig: #{self.inspect} | duped: #{duped_piece.inspect} | dest: #{current_move}"
      end

      duped_board.render
      sleep(1)
    end

    puts "Finished performing move sequence."
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

  def enemy?(other_piece)
    self.color != other_piece.color
  end

  def to_s
    id.colorize(color)
  end

  def inspect
    king? ? "#{color} king at #{location}" : "#{color} piece at #{location}"
  end

  def dup(duped_board)
    Piece.new(self.location, duped_board, self.color, self.king)
  end
end

class IllegalMoveError < RuntimeError
end
