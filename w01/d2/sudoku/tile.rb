require "colorize"

class TileError < RuntimeError
end

class Tile
  attr_reader :given, :value

  def value=(some_val)
    raise TileError.new("Can't change a predefined tile!") if given
    @value = some_val
  end

  def initialize(value, given = false)
    @value = value
    @given = given
  end

  def to_s
    given ? value.red : value
  end

end
