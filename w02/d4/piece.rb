require 'colorize'

 MOVE_DIFFS = { :red => [[1, 1], [1, -1]], :black => [[-1, 1], [-1, -1]] }
 JUMP_DIFFS = { :red => [[2, 2], [2, -2]], :black => [[-2, 2], [-2, -2]] }

class Piece
  attr_reader :color, :id, :king_row
  attr_accessor :location, :board, :king

  def initialize(location, board, color, king = false)
    @location = location
    @board = board
    @color = color # either :red or :black
    @king = king
    @king_row = (color == :black) ? 0 : 7
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
    maybe_promote
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

    unless enemy?(between_piece) && moves(:jumping).include?(destination)
      raise IllegalMoveError, "\n#{self.inspect} can't jump to #{destination}!"
    end

    move_to(destination)
    board.remove_piece(between_piece.location)
  end

  def perform_moves(*move_seq)
    perform_moves!(*move_seq) if valid_move_seq?(*move_seq)
  end

  def perform_moves!(*move_seq)
    origin = self.location

    until move_seq.empty?
      current_move = move_seq.shift

      if moves(:sliding).include?(current_move)
        self.perform_slide(current_move)
        break

      elsif moves(:jumping).include?(current_move)
        self.perform_jump(current_move)

      else
        raise IllegalMoveError, "#{self.inspect} (from #{origin}) can't get to #{current_move}!"
      end
    end
  end

  def valid_move_seq?(*move_seq)
    begin
      duped_board = board.dup
      duped_piece = duped_board[location]
      duped_piece.perform_moves!(*move_seq) #needs the splat also
    rescue IllegalMoveError
      # puts "Not a valid sequence!"
      return false
    ensure
      # puts "Done with move checking."
    end

    # puts "Valid!"
    true
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

  def maybe_promote
    king_me! if location.first == king_row
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
    return false if other_piece.color == :empty
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
