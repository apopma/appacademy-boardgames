require 'deck'
require 'rspec'

describe Deck do
  subject(:new_deck) { Deck.new }
  describe "#initialize" do

    it "should be initialized with 52 cards" do
      expect(new_deck.length).to eq(52) #unkosher?
    end

    it "contains no duplicate cards" do
      expect(new_deck.length).to eq(new_deck.cards.uniq.length) #bluh
    end
  end

  describe "#shuffle" do
    it "shuffles its cards" do
      expect(new_deck.cards).to receive(:shuffle!)

      new_deck.shuffle
    end
  end
end
