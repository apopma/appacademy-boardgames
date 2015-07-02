class EmptySquare
  def to_s
    " "
  end

  def empty?
    true
  end

  def king?
    false
  end

  def enemy?(_)
    false
  end

  def move_diffs
    []
  end

  def inspect
    "empty square"
  end

  def dup
    self #EmptySquare.new if this breaks
  end
end
