class CheckersGame
  attr_accessor :board, :players

  def initialize
    @board = Board.new
    @players = [Player.new(:black), Player.new(:red)]
    board.setup
  end

  def play

  end

  def next_player
    @players << @players.shift
  end


end

if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Checkers!"
  CheckersGame.new.play
end
