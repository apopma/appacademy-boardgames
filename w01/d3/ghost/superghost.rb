require_relative 'ghost'

class SuperGhostGame < GhostGame
  attr_reader :prepend

  def initialize(players)
    super
    @prepend = false
  end

  # ----------------------------------------------------------------------------

  def valid_play?(string)
    return false if string.empty?
    return true if word_found?

    if @prepend
      possible_new_fragment = string + fragment
    else
      possible_new_fragment = fragment + string
    end

    result = ("a".."z").to_a.include?(string) &&
      dictionary.any? { |word| word.include?(possible_new_fragment) }
    unless result
      puts "#{possible_new_fragment} isn't in the dictionary. Try again!"
    end

    result
  end

 # -----------------------------------------------------------------------------

  private

  def take_turn(player)
    until valid_play?(current_guess)
      print "(#{fragment}) "
      @current_guess = player.guess

      print "Do you want to place this letter at the beginning? (y/n) >"
      prepending = gets.chomp.downcase
      prepending == "y" ? @prepend = true : @prepend = false
    end

    add_to_fragment(current_guess)
    @current_guess = ''

    system("clear")
    players.each { |player| puts "#{player.name} has #{record(player.name)}." }
  end

  def add_to_fragment(string)
    if @prepend
      @fragment = string + @fragment
    else
      fragment << string
    end
  end
end

# ==============================================================================

if __FILE__ == $PROGRAM_NAME
  num_players = ARGV.shift.to_i
  puts "Welcome to Superghost!"
  puts "There will be #{num_players} players in this game."

  players = []
  num_players.times do
    players << Player.new
  end

  SuperGhostGame.new(players).run
end

