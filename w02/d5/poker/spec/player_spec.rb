require 'player'
require 'rspec'

describe Player do
  describe "#initialize" do
    subject(:player) { Player.new("Bob") }
    subject(:moneybags) { Player.new("Richie Rich", 5000) }

    it "should have a name" do
      expect(player.name).to eq("Bob")
    end

    it "should start with a hundred chips" do
      expect(player.bank).to eq(100)
    end

    it "should start with an empty hand" do
      expect(player.hand).to be_empty
    end

    it "should accept a starting bank if one is given" do
      expect(moneybags.bank).to eq(5000)
  end

  describe "#bet" do
    it "subtracts the bet from the player's bank"

    end

    it "raises an error if the player is too poor"

    end

    it "won't place a zero bet"

    end
  end

  describe "#check" do
    it "returns true if the player checks"

    end

    it "returns false if the player bets or folds"

    end
  end

  describe "#call" do
    it "subtracts the bet amount from the user's bank"

    end

    it "raises an error if the player is too poor"

    end
  end

  describe "#raise" do
    it "subtracts the bet plus the amount to raise from the bank"

    end

    it "raises an error if the player is too poor"

    end

  end

  describe "#fold" do
    it "takes the player out of the betting order"

    end

    it "doesn't let the player bet again until the next game begins"

    end
  end
end
