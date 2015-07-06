class Player
  attr_reader :name
  attr_accessor :bank

  def initialize(name, bank = 100)
    @name, @bank = name, bank
  end

  def bet(amt)
    raise "can't cover bet" unless bank >= amt

  end
end
