require 'byebug'
require 'set'
require 'colorize'

class Tile
  attr_accessor :seen, :mine
  attr_reader :board, :pos, :flagged

  DIFFS = [
    [-1, -1], [-1, 0], [-1, 1],
    [ 0, -1],          [ 0, 1],
    [ 1, -1], [ 1, 0], [ 1, 1]
  ]

  COLORS = {
    0 => :default, 1 => :light_blue, 2 => :green,
    3 => :red,     4 => :purple,     5 => :blue,
    6 => :cyan,    7 => :black,      8 => :magenta
  }

  def initialize(board, pos)
    @board = board
    @seen = false
    @mine = false
    @pos = pos
    @flagged = false
  end

  def reveal
    if self.mine
      @seen = true # non-mines are revealed within reveal_neighbors
      return
    end

    reveal_neighbors
  end

  def reveal_neighbors(visited = Set.new)
    return if visited.include?(self) || self.mine || self.flagged
    visited << self
    @seen = true

    if self.danger_zone == 0
      neighbors.each do |neighbor|
        neighbor.reveal_neighbors(visited)
      end
    end
  end

  def lay_mine
    @mine = true
  end

  def neighbors # array of neighboring tile objects
    all_pos = DIFFS.map do |dy, dx|
      row, col = pos
      [row + dy, col + dx]
    end

    valid_pos = all_pos.select { |candidate| board.on_board?(candidate) }
    valid_pos.map { |pos| board[pos] }
  end

  def danger_zone # amount of neighbors that are mines
    neighbors.count(&:mine)
  end

  def inspect
    "TILE seen: #{@seen} | mine: #{@mine} | flagged: #{@flagged} | pos: #{@pos}"
  end

  def to_s
    if flagged
      "⚑"
    elsif !seen   # unseen yet, may or may not be a mine
      "·"
    elsif !mine
      if danger_zone == 0
        " "
      else
        danger_zone.to_s.colorize(COLORS[danger_zone])
      end
      
    else          # mine, never seen until game is lost or won
      "*".yellow.on_black
    end
  end

  def toggle_flag
    @flagged = !@flagged
  end
end
