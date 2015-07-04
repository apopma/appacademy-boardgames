require 'card'
require 'rspec'

describe Card do
  describe "#initialize" do
    subject(:new_card) { Card.new(:ace, :spades) }

    it "should have a suit" do
      expect(new_card.suit).to eq(:spades)
    end

    it "should have a value" do
      expect(new_card.value).to eq(:ace)
    end
  end
end
