require_relative 'player'
require_relative 'board'
require 'io/console'
require 'yaml'

KEYBINDINGS = {
  'w' => [-1, 0], 'a' => [0, -1],
  's' => [1, 0],  'd' => [0, 1]
}

class ChessGame
  def initialize(player1 = HumanPlayer.new(:white),
                 player2 = HumanPlayer.new(:black))
    @chessboard = Board.new
    @players = [player1, player2]
    chessboard.populate_grid
  end

  def play
    begin
      play_turn until over?
      chessboard.render
      puts "Game over. #{players.last.color.capitalize} wins!"

    rescue QuitGame
      puts "Thanks for playing."
      return
    end
  end

  def play_turn
    #move the cursor around, displaying moves for current player
    message = "It's #{current_player.color.capitalize}'s turn."
    message += "\nWASD to move, Space to select, Enter to make move."
    message += "\nQ to save and P to quit."

    if chessboard.in_check?(current_player.color)
      message += "\nYou are currently in check."
    end
    input = get_player_input(message)

    if chessboard.valid_move?(*input)
      chessboard.move!(*input)
      next_player
    end
  end

  def get_player_input(message)
    chessboard.reset_selection
    loop do
      input = input_from_cursor(message)
      return input if input
    end
  end

  def input_from_cursor(message)
    chessboard.render
    #chessboard.debug_info
    puts message

    input = current_player.get_input # Player#get_input rescues bad input
    case input
    when ' '
      chessboard.select_pos(current_player.color)
      return nil

    when "\r"
      result = chessboard.cursor_info
      return result unless result.first.nil?
      return nil

    when "q"
      save_game
      return nil

    else
      move_cursor(KEYBINDINGS[input])
      return nil
    end
  end

  def move_cursor(diff)
    chessboard.move_cursor(diff)
  end

  def over?
    chessboard.checkmate?(current_player.color)
  end

  def next_player
    players << players.shift
  end

  def current_player
    players.first
  end

  def save_game
    print "Enter the name you want your savefile to have (q to cancel): "
    savename = "#{gets.chomp}.yml"
    return if savename.downcase == "q.yml"
    File.open(savename, 'w') do |f|
      f.puts self.to_yaml
    end

    puts "Game has been saved."
    sleep(1)
    return
  end

  private
  attr_accessor :chessboard, :players
end


 if __FILE__ == $PROGRAM_NAME
   puts "Welcome to Chess!"
   input = nil
   until ["1","2"].include?(input)
     puts "1: begin new game"
     puts "2: load existing game"
     input = gets.chomp
   end

   if input == "1"
     ChessGame.new.play
   else
     puts "what is the name of the file?"
     file = "#{gets.chomp}.yml"
     save = File.read(file)
     YAML::load(save).play
   end
 end
