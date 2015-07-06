require 'rspec'
require 'player'

describe Player do
  before(:each) do
    subject(:player) { Player.new("Slate Slabrock", 100) }
  end

  describe "#initialize" do
    subject(:bob) { Player.new("Bob") }
    subject(:moneybags) { Player.new("Richie Rich", 5000) }

    it "should have a name" do
      expect(bob.name).to eq("Bob")
    end

    it "should start with a hundred chips" do
      expect(bob.bank).to eq(100)
    end

    it "should start with an empty hand" do
      expect(bob.hand).to be_empty
    end

    it "should accept a starting bank if one is given" do
      expect(moneybags.bank).to eq(5000)
    end
  end

  describe "#bet" do
    it "subtracts the bet from the player's bank" do
      player.bet(50)
      expect(player.bank).to eq(50)
    end

    it "raises an error if the player is too poor" do
      expect(player.bet(500)).to raise_error
    end

    it "won't place a zero bet" do
      expect(player.bet(0)).to raise_error
    end
  end

  # describe "#check" do
  #   it "returns true if the player checks" do
  #
  #   end
  #
  #   it "returns false if the player bets or folds" do
  #
  #   end
  # end

  describe "#call" do
    it "subtracts the bet amount from the user's bank" do

    end

    it "raises an error if the player is too poor" do

    end
  end

  describe "#raise" do
    it "subtracts the bet plus the amount to raise from the bank" do

    end

    it "raises an error if the player is too poor" do

    end

  end

  describe "#fold" do
    it "takes the player out of the betting order" do

    end

    it "doesn't let the player bet again until the next game begins" do

    end
  end
end
