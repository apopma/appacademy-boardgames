require 'colorize'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7, nil) }
  end


  def [](pos)
    row, col = pos
    grid[row][col]
  end


  def four_in_line(player_id)
    Array.new(4, player_id)
  end


  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end


  def render
    @grid.each do |row|
      row_str = ""
      row.each do |spot|
        row_str << spot_id(spot)
      end
      puts row_str.strip
    end
  end


  def spot_id(spot)
    case spot
    when nil
      "o "
    when :a
      "* ".red
    when :b
      "* ".blue
    end
  end

  def over?(player_id)
    return true if search_horizontal_or_vertical(player_id, grid)  	     ||
                   search_horizontal_or_vertical(player_id, transposed_grid) ||
                   search_diagonal_up(player_id) 			     ||
                   search_diagonal_down(player_id)
    false
  end

  def winner
    [:a, :b].each do |player|
      return player if over?(player)
    end
    nil
  end


  def transposed_grid
    grid.transpose
  end


  def search_horizontal_or_vertical(player_id, grid)
    grid.each do |row|
      (0..3).each do |spot|
        return true if row[spot..(spot + 3)] == four_in_line(player_id)
      end
    end
    false
  end


  def search_diagonal_up(player_id)
    # TODO: make this recursive?
    (3..5).each do |row|
      (0..3).each do |col|
        return true if [
          grid[row][col],
          grid[row - 1][col + 1],
          grid[row - 2][col + 2],
          grid[row - 3][col + 3]
                       ] == four_in_line(player_id)
      end
    end
    false
  end

  def search_diagonal_down(player_id)
    # TODO: make this recursive?
    (0..2).each do |row|
      (0..3).each do |col|
        return true if [
          grid[row][col],
          grid[row + 1][col + 1],
          grid[row + 2][col + 2],
          grid[row + 3][col + 3]
                       ] == four_in_line(player_id)
      end
    end
    false
  end


  def drop_disc(col, disc)
    pos = [bottom_row(col), col]
    self[pos] = disc
  end


  def bottom_row(col)
    5 - (transposed_grid[col].compact.length)
  end

  def full?
    grid.flatten.all? { |spot| spot }
  end
end
