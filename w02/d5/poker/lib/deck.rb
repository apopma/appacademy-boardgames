require_relative 'card'

class Deck
  attr_accessor :cards

  SUITS = [:spades, :hearts, :diamonds, :clubs]
  VALUES = [:ace, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten,
            :jack, :queen, :king]

  def initialize
    @cards = []
    create_deck
  end

  def length
    cards.length
  end

  def create_deck
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << Card.new(value, suit)
      end
    end
  end

  def shuffle
    cards.shuffle!
  end
end
