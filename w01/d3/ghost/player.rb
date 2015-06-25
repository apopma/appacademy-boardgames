class Player
  attr_reader :name

  def initialize
    @name = register_name
  end

  def guess
    print "#{self.name}, enter a single letter to guess: >"
    gets.chomp.downcase
  end

  def register_name
    print "Enter your name please: "
    gets.chomp.capitalize
  end
end

