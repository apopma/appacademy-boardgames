require_relative 'player'
require_relative 'board'
require 'io/console'

KEYBINDINGS = {
  'w' => [-1, 0], 'a' => [0, -1],
  's' => [ 1, 0], 'd' => [0,  1]
}

class CheckersGame
  attr_accessor :board, :players

  def initialize
    @board = Board.new
    @players = [Player.new(:black), Player.new(:red)]
    board.setup
  end

  def play
    begin
      play_turn until over?
      board.render
      puts "Game over. #{players.last.color.capitalize} wins!"

    rescue QuitGame
      puts "Thanks for playing!"
      return
    end
  end

  def over?
    players.any? do |player|
      board.grid.flatten.none? { |piece| piece.color == player.color }
    end
  end

  def play_turn
    #move the cursor around, displaying moves for current player
    message = "It's #{current_player.color.capitalize}'s turn."
    message += "\nWASD to move, Space to select, Enter to make move."
    message += "\nPress P to quit."

    input = get_player_input(message)
  end

  def get_player_input(message)
    board.reset_selection
    loop do
      input = input_from_cursor(message)
      return input if input
    end
  end

  def input_from_cursor(message)
    board.render
    #board.debug_info
    puts message

    input = current_player.get_input # Player#get_input rescues bad input
    case input
    when ' '
      board.select_pos(current_player.color)
      return nil

    when "\r"
      result = board.cursor_info
      return result unless result.first.nil?
      return nil

    else
      move_cursor(KEYBINDINGS[input])
      return nil
    end
  end

  def move_cursor(diff)
    board.move_cursor(diff)
  end


  def next_player
    @players << @players.shift
  end

  def current_player
    @players.first
  end


end

if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Checkers!"
  sleep(0.5)
  CheckersGame.new.play
end
