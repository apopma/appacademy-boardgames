class EmptySquare
  def empty?
    true
  end

  def color
    :empty
  end

  def to_s
    " "
  end

  def dup(duped_board)
    EmptySquare.new
  end

  def moves
    []
  end

  def king?
    false
  end

  def enemy?
    false
  end

  def rook_unmoved?
    false
  end

end
