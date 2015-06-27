require_relative 'tic_tac_toe'
require 'byebug'

class TicTacToeNode
  PLAYERS = [:x, :o]
  attr_reader :board, :next_mover_mark
  attr_accessor :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    opponent = evaluator == :x ? :o : :x
    return true if board.over? && board.winner == opponent
    return false if board.over?

    if evaluator == next_mover_mark
      children.all? do |child_node|
        child_node.losing_node?(evaluator)
      end
    else
      children.any? do |child_node|
        child_node.winning_node?(opponent)
      end
    end
  end

  def winning_node?(evaluator)
    opponent = evaluator == :x ? :o : :x
    return true if board.over? && board.winner == evaluator
    return false if board.over?

    if evaluator == next_mover_mark
      children.any? do |child_node|
        child_node.winning_node?(evaluator)
      end
    else
      children.all? do |child_node|
        child_node.losing_node?(opponent)
      end
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    kids = []
    opponent = next_mover_mark == :x ? :o : :x

    board.rows.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if board.empty?([row_index, col_index])
          duped_board = board.dup
          duped_board[[row_index, col_index]] = next_mover_mark
          kids << TicTacToeNode.new(duped_board, opponent, [row_index, col_index])
        end
      end
    end

    kids
  end
end
