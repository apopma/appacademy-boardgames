class Player
  def get_pos
    pattern = /^(\d+) (\d+)$/
    msg = "Please enter a row, then a column (e.g. '3 4'): "

    pos_string = prompt(pattern, msg)
    pos_string.drop(1).map(&:to_i)
  end

  def get_move
    pattern = /^[FR]$/i
    msg = "Flag or reveal? (F: flag/unflag, R: reveal): "

    move_string = prompt(pattern, msg)
    move_string.first.downcase.to_sym
  end

  def prompt(pattern, msg)
    print msg
    input = gets.chomp

    unless pattern =~ input
      puts "Invalid input. Please try again."
      return prompt(pattern, msg)
    end

    pattern.match(input).to_a
  end

end
