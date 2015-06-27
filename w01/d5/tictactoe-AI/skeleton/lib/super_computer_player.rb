require_relative 'tic_tac_toe_node'
require "byebug"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    board = game.board.dup
    root_node = TicTacToeNode.new(board, mark)

    root_node.children.each do |child|
      return child.prev_move_pos if child.winning_node?(mark)
    end

    #implied none are winning nodes
    root_node.children.each do |child|
      return child.prev_move_pos unless child.losing_node?(mark)
    end

    # if no non-losing nodes, should never happen
    if root_node.children.all? { |child| child.losing_node?(mark) }
      raise "(╯°□°）╯︵ ┻━┻"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
