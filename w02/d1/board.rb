require_relative 'tile'

class Board
  attr_accessor :grid, :num_mines, :num_rows, :num_cols

  def initialize(num_rows, num_cols, num_mines)
    @grid = Array.new(num_rows) { Array.new(num_cols) }

    num_rows.times do |row|
      num_cols.times do |col|
        @grid[row][col] = Tile.new(self, [row, col]) # passes board and tile pos
      end

    @num_rows = num_rows
    @num_cols = num_cols
    @num_mines = num_mines
    end

    self.lay_mines
  end

  def lay_mines
    @grid.flatten.sample(num_mines).each(&:lay_mine)
  end

  def on_board?(pos)
    row, col = pos
    row.between?(0, num_rows - 1) && col.between?(0, num_cols - 1)
  end

  def uncover
    @grid.flatten.each(&:reveal)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def reveal(pos)
    self[pos].reveal
  end

  def display
    print '  '

    num_cols.times { |i| print format("%3d", i) }
    puts

    grid.each_with_index do |row, idx|
      row_string = format("%2d ", idx)
      row.each do |tile|
        row_string << " #{tile.to_s} "
      end
      puts row_string
    end
  end

  def won?
    # true if all non-mines have been seen
    return if grid.flatten.all? { |tile| tile.seen ^ tile.mine }

    # also true if all mines are flagged
    grid.flatten.select(&:mine).all?(&:flagged)
  end

  def lost?
    grid.flatten.any? { |tile| tile.seen && tile.mine }
  end
end
