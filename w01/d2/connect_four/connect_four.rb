require_relative 'board'

class ConnectFour
  attr_reader :board, :players

  def initialize
    @board = Board.new
    @players = [:a, :b]
  end

  def run
    board.render

    loop do
      players.each do |player|

        input = prompt(player)
        until valid_input?(input)
          input = prompt(player)
        end

        board.drop_disc(input, player)
        board.render
        break if board.winner || board.full?
      end
      break if board.winner || board.full?
    end

    puts "Player #{board.winner.to_s.upcase} is the winner!" if board.winner
    puts "Nobody won!" if board.full?

  end

  def valid_input?(input)
    input && input.between?(0, 6) && !column_full?(input)
  end

  def column_full?(col)
    col_has_no_empties = board.transposed_grid[col].compact.size == 6
    puts "That column's full; try again!" if col_has_no_empties
    col_has_no_empties
  end

  def prompt(player)
    print "Player #{player.to_s.upcase}, which column do you choose (0 to 6)? "
    gets.chomp.to_i
  end
end

ConnectFour.new.run
