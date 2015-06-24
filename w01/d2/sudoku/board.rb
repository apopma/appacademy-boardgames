require_relative "tile"
require 'byebug'

class RowError < RuntimeError
end

class ColumnError < RuntimeError
end

class GroupError < RuntimeError
end

class Board
  attr_reader :grid, :raw_puzzle
  BOARD_EXCEPTIONS = [RowError, ColumnError, GroupError]

  def self.from_file
     raw_puzzle = File.readlines("#{ARGV.shift}.txt")
     raw_puzzle.map!(&:chomp)
     Board.new(raw_puzzle)
  end

  def initialize(raw_puzzle)
    @raw_puzzle = raw_puzzle
    @grid = Array.new(9) { Array.new(9) }
    parse_raw_puzzle
  end

  def parse_raw_puzzle
    raw_puzzle.each_with_index do |row, row_idx|
      row.split('').each_with_index do |cell, col_idx|
        case cell.to_i
        when 0
          grid[row_idx][col_idx] = Tile.new('_', false)
        else
          grid[row_idx][col_idx] = Tile.new(cell, true)
        end
      end
    end
  end

  def rows
    result = []
    (0..8).each do |row|
      current_row = []
      (0..8).each do |col|
        current_row << [row, col]
      end
      result << current_row
    end
    result
  end

  def cols
    result = []
    (0..8).each do |row|
      current_col = []
      (0..8).each do |col|
        current_col << [col, row]
      end
      result << current_col
    end
    result
  end

  def groups
    [
      [
        [0, 0], [0, 1], [0, 2],
        [1, 0], [1, 1], [1, 2],
        [2, 0], [2, 1], [2, 2]
      ],

      [
        [3, 0], [3, 1], [3, 2],
        [4, 0], [4, 1], [4, 2],
        [5, 0], [5, 1], [5, 2]
      ],

      [
        [6, 0], [6, 1], [6, 2],
        [7, 0], [7, 1], [7, 2],
        [8, 0], [8, 1], [8, 2]
      ],

      [
       [0, 3], [0, 4], [0, 5],
       [1, 3], [1, 4], [1, 5],
       [2, 3], [2, 4], [2, 5]
      ],

      [
        [0, 6], [0, 7], [0, 8],
        [1, 6], [1, 7], [1, 8],
        [2, 6], [2, 7], [2, 8]
      ],

      [
        [3, 3], [3, 4], [3, 5],
        [4, 3], [4, 4], [4, 5],
        [5, 3], [5, 4], [5, 5]
      ],

      [
        [3, 6], [3, 7], [3, 8],
        [4, 6], [4, 7], [4, 8],
        [5, 6], [5, 7], [5, 8]
      ],

      [
        [6, 3], [6, 4], [6, 5],
        [7, 3], [7, 4], [7, 5],
        [8, 3], [8, 4], [8, 5]
      ],

      [
        [6, 6], [6, 7], [6, 8],
        [7, 6], [7, 7], [7, 8],
        [8, 6], [8, 7], [8, 8]
      ]
    ]
  end

  def get_tile_update
    begin
      print "Which position (0 to 8, row then column, separated by a space)? "
      pos = gets.chomp.split.map(&:to_i)
      print "And what number do you want to put there? (1 through 9) "
      val = gets.chomp.to_i
      update_tile(pos, val)

    rescue TileError => e #lambda??
      puts e.message
      retry

    rescue *BOARD_EXCEPTIONS => e
      puts e.message
      retry

    end
  end

  def update_tile(pos, new_val)
    row, col = pos

    if row_collision?(pos, new_val)
      raise RowError.new("#{new_val} already exists in this row!")
    end

    if col_collision?(pos, new_val)
      raise ColumnError.new("#{new_val} already exists in this column!")
    end

    if group_collision?(pos, new_val)
      raise GroupError.new("#{new_val} already exists in this group!")
    end

    grid[row][col].value = new_val
  end

  def row_collision?(pos, val)
  end

  def col_collision?(pos, val)
  end

  def group_collision?(pos, val)
  end

  def render
    grid.each do |row|
      row_string = ''

      row.each do |tile|
        row_string << "#{tile.to_s} "
      end

      puts row_string.chomp
    end
  end

end

b = Board::from_file
b.render
