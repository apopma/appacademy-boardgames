require_relative 'board'
require_relative 'player'

class MinesweeperGame
  attr_reader :player, :action, :board

  def initialize(game_rows, game_cols, game_mines)
    @board = Board.new(game_rows, game_cols, game_mines)
    @player = Player.new
    @action = { :f => :toggle_flag, :r => :reveal }
  end

  def play
    render

    loop do
      move = player.get_move
      pos = get_position
      board[pos].send action[move]
      render

      if board.won?
        puts "You won!"
        board.uncover
        break

      elsif board.lost?
        puts "You lost!"
        board.uncover
        break

      end
    end

    sleep(2)
    render
    puts "Game over!"
  end

  def get_position
    loop do
      pos = player.get_pos
      return pos if board.on_board?(pos)
      puts "Position out-of-bounds! Try again."
    end
  end

  def render
    system('clear')
    board.display
  end

end


if __FILE__ == $PROGRAM_NAME
  puts 'Welcome to Minesweeper!'
  print "How many rows will this board have? "
  game_rows = gets.chomp.to_i

  print "How many columns? "
  game_cols = gets.chomp.to_i

  print "How many mines? "
  game_mines = gets.chomp.to_i

  puts "Let's play the game!"
  MinesweeperGame.new(game_rows, game_cols, game_mines).play
end
