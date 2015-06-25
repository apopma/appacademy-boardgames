require 'set'
require_relative 'player'

class GhostGame
  def self.parse_dictionary
    words = File.readlines("ghost-dictionary.txt").map!(&:chomp)
    Set.new(words)
  end

  attr_reader :dictionary, :fragment, :losses, :players, :current_guess

  def initialize(players)
    @fragment = ""
    @dictionary = self.class.parse_dictionary
    @players = players
    @current_guess = ""
    @losses = build_losses
  end

  # ----------------------------------------------------------------------------

  def run
    play_one_game until players.size == 1
    puts "Congratulations, #{players.first.name} is the winner!"
  end

  def play_one_game
    play_round until word_found?
    puts "#{previous_player.name} has lost." +
         " The word found was '#{fragment}'."

    losses[previous_player.name] += 1
    players.each do |player|
      puts "#{player.name} has lost!" if losses[player.name] == 5
    end

    @fragment = ''
    drop_losers
  end

  def play_round
    take_turn(current_player)
    next_player!
  end

  # ----------------------------------------------------------------------------

  def record(name)
    return "_" if losses[name] == 0
    "#{"GHOST".slice(0...losses[name])}"
  end

  def valid_play?(string)
    return false if string.empty?
    return true if word_found?

    possible_new_fragment = fragment + string

    result = ("a".."z").to_a.include?(string) &&
      dictionary.any? { |word| word.include?(possible_new_fragment) }

    unless result
      puts "#{possible_new_fragment} isn't in the dictionary. Try again!"
    end

    result
  end

  # ----------------------------------------------------------------------------

  private
  def take_turn(player)
    @current_guess = player.guess until valid_play?(current_guess)
    add_to_fragment(current_guess)
    @current_guess = ''

    system("clear")
    players.each { |player| puts "#{player.name} has #{record(player.name)}." }
  end

  def add_to_fragment(string)
    fragment << string
    puts "The fragment is now #{fragment}."
  end

  def current_player
    players.first
  end

  def previous_player
    players.last
  end

  def next_player!
    players << players.shift
  end

  def word_found?
    dictionary.include?(fragment)
  end

  def drop_losers
    players.delete_if { |player| losses[player.name] == 5 }
    losses.delete_if { |player, loss| loss == 5 }
  end

  def build_losses
    losses_hash = {}
    players.each do |player|
      losses_hash[player.name] = 0
    end
    losses_hash
  end
end

# ==============================================================================

if __FILE__ == $PROGRAM_NAME
  num_players = ARGV.shift.to_i
  puts "Welcome to Ghost!"
  puts "There will be #{num_players} players in this game."

  players = []
  num_players.times do
    players << Player.new
  end

  GhostGame.new(players).run
end

