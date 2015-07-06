require 'hand'
require 'rspec'

describe Hand do
  let(:s2)  { double('s2', :value => :two, :suit => :spades) }
  let(:s3)  { double('s3', :value => :three, :suit => :spades) }
  let(:s4)  { double('s4', :value => :four, :suit => :spades) }
  let(:s5)  { double('s5', :value => :five, :suit => :spades) }
  let(:s6)  { double('s6', :value => :six, :suit => :spades) }
  let(:s7)  { double('s7', :value => :seven, :suit => :spades) }
  let(:s8)  { double('s8', :value => :eight, :suit => :spades) }
  let(:s9)  { double('s9', :value => :nine, :suit => :spades) }
  let(:s10) { double('s10', :value => :ten, :suit => :spades) }
  let(:sj)  { double('sj', :value => :jack, :suit => :spades) }
  let(:sq)  { double('sq', :value => :queen, :suit => :spades) }
  let(:sk)  { double('sk', :value => :king, :suit => :spades) }
  let(:sa)  { double('sa', :value => :ace, :suit => :spades) }

  let(:h3)  { double('h3', :value => :three, :suit => :hearts) }
  let(:h4)  { double('h4', :value => :four, :suit => :hearts) }
  let(:h7)  { double('h7', :value => :seven, :suit => :hearts) }
  let(:hq)  { double('hq', :value => :queen, :suit => :hearts) }
  let(:ha)  { double('ha', :value => :ace, :suit => :hearts) }

  let(:d4)  { double('c3', :value => :four, :suit => :diamonds) }
  let(:d7)  { double('d7', :value => :seven, :suit => :diamonds) }
  let(:dq)  { double('dq', :value => :queen, :suit => :diamonds) }
  let(:d10) { double('d10', :value => :ten, :suit => :diamonds) }

  let(:c7)  { double('c7', :value => :seven, :suit => :clubs) }
  let(:cq)  { double('cq', :value => :queen, :suit => :clubs) }
  let(:c10) { double('c10', :value => :ten, :suit => :clubs) }

  subject(:royal_flush_hand)     { Hand.new([s10, sj, sq, sk, sa]) }
  subject(:straight_flush_hand)  { Hand.new([s3, s4, s5, s6, s7]) }
  subject(:four_of_a_kind_hand)  { Hand.new([s7, h7, d7, c7, s2]) }
  subject(:full_house_hand)      { Hand.new([s7, h7, d7, sq, hq]) }
  subject(:flush_hand)           { Hand.new([s2, s4, s7, s9, sj]) }
  subject(:straight_hand)        { Hand.new([s5, s6, h7, s8, s9]) }
  subject(:three_of_a_kind_hand) { Hand.new([s7, h7, d7, hq, s3]) }
  subject(:two_pair_hand)        { Hand.new([s7, d7, sq, hq, s2]) }
  subject(:one_pair_hand)        { Hand.new([d4, h4, s2, s3, s7]) }
  subject(:ace_high_hand)        { Hand.new([sa, h7, hq, s3, s5]) }
  subject(:garbage_hand)         { Hand.new([s2, s5, s4, d7, h3]) }

  describe "#initialize" do
    context "when no args are given" do
      subject(:new_hand) { Hand.new }

      it "should be empty" do
        expect(new_hand.cards).to be_empty
      end
    end

    context "when args are given" do
      subject(:new_hand) { Hand.new([s2]) }

      it "has a card" do
        expect(new_hand.cards).not_to be_empty
      end
    end
  end

  describe "#remove_card" do
    it "responds to the method" do
      expect(ace_high_hand).to respond_to(:remove_card)
    end

    it "removes a card at the given index" do
      ace_high_hand.remove_card(3)

      expect(ace_high_hand.cards).not_to include s3
    end
  end

  describe "#add_card" do
    subject(:four_cards) { Hand.new([s4, d7, s8, s10]) }

    it "adds the card given" do
      four_cards.add_card(sq)

      expect(four_cards.cards).to include sq
      expect(four_cards.cards.size).to eq(5)
    end
  end

  describe "#straight_flush?" do
    it "returns true for a real straight flush" do
      expect(straight_flush_hand.straight_flush?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.straight_flush?).to be false
    end
  end

  describe "#four_of_a_kind?" do
    it "returns true for a real four-of-a-kind" do
      expect(four_of_a_kind_hand.four_of_a_kind?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.four_of_a_kind?).to be false
    end
  end

  describe "#full_house?" do
    it "returns true for a real full house" do
      expect(full_house_hand.full_house?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.full_house?).to be false
    end
  end

  describe "#straight?" do
    it "returns true for a real straight" do
      expect(straight_hand.straight?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.straight?).to be false
    end
  end

  describe "#flush?" do
    it "returns true for a real flush" do
      expect(flush_hand.flush?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.flush?).to be false
    end
  end

  describe "#three_of_a_kind?" do
    it "returns true for a real three-of-a-kind" do
      expect(three_of_a_kind_hand.three_of_a_kind?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.three_of_a_kind?).to be false
    end
  end

  describe "#two_pair?" do
    it "returns true for a real two pair" do
      expect(two_pair_hand.two_pair?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.two_pair?).to be false
    end
  end

  describe "#pair?" do
    it "returns true for a real pair" do
      expect(one_pair_hand.pair?).to be true
    end

    it "returns false for any other hand" do
      expect(garbage_hand.pair?).to be false
    end
  end

  describe "#beats?" do
    context "a straight flush" do
      it "beats four of a kind" do
        expect(straight_flush_hand.beats?(four_of_a_kind_hand)).to be true
      end

      it "loses to a royal flush" do
        expect(straight_flush_hand.beats?(royal_flush_hand)).to be false
      end
    end

    context "four of a kind" do
      # subject(:four_of_a_kind_hand)  { Hand.new([s7, h7, d7, c7, s2]) }
      subject(:four_queens_hand)       { Hand.new([sq, hq, dq, cq, s3]) }

      it "beats a full house" do
        expect(four_of_a_kind_hand.beats?(full_house_hand)).to be true
      end

      it "loses to a higher four of a kind" do
        expect(four_of_a_kind_hand.beats?(four_queens_hand)).to be false
      end
    end

    context "a full house" do
      # subject(:full_house_hand)      { Hand.new([s7, h7, d7, sq, hq]) }
      subject(:queens_and_sevens_hand) { Hand.new([sq, hq, dq, c7, d7]) }
      subject(:sevens_and_aces_hand)   { Hand.new([s7, h7, d7, sa, ha]) }

      it "beats a flush" do
        expect(full_house_hand.beats?(flush_hand)).to be true
      end

      it "loses to a higher full house" do
        expect(full_house_hand.beats?(queens_and_sevens_hand)).to be false
      end

      it "breaks ties with two-of-a-kind if three-of-a-kind match" do
        expect(sevens_and_aces_hand.beats?(full_house_hand)).to be true
      end


    end

    context "a flush" do
      # subject(:flush_hand)    { Hand.new([s2, s4, s7, s9, sj]) }
      subject(:jack_ten_flush)  { Hand.new([sj, s2, s4, s6, s10]) }
      subject(:ace_high_flush)  { Hand.new([sa, s2, s4, s7, s9]) }

      it "beats a straight" do
        expect(flush_hand.beats?(straight_hand)).to be true
      end

      it "loses to a better high card" do
        expect(flush_hand.beats?(ace_high_flush)).to be false
      end

      # TODO do this later for other kinds of hands?
      it "checks multiple high cards if the highest match" do
        expect(flush_hand.beats?(jack_ten_flush)).to be false
      end
    end

    context "a straight" do
      #subject(:straight_hand)    { Hand.new([s5, s6, h7, s8, s9]) }
      subject(:ace_high_straight) { Hand.new ([sa, sk, sq, sj, d10]) }

      it "beats three-of-a-kind" do
        expect(straight_hand.beats?(three_of_a_kind_hand)).to be true
      end

      it "loses to a better high card" do
        expect(straight_hand.beats?(ace_high_straight)).to be false
      end
    end

    context "three of a kind" do
      # subject(:three_of_a_kind_hand) { Hand.new([s7, h7, d7, hq, s3]) }
      subject(:three_queens_hand)      { Hand.new([sq, hq, dq, s2, s3]) }

      it "beats two pair" do
        expect(three_of_a_kind_hand.beats?(two_pair_hand)).to be true
      end

      it "loses to a better three-of-a-kind" do
        expect(three_of_a_kind_hand.beats?(three_queens_hand)).to be false
      end
    end

    context "two pair" do
      # subject(:two_pair_hand)      { Hand.new([s7, d7, sq, hq, s2]) }
      subject(:tens_and_queens_hand) { Hand.new([s10, sq, hq, d10, d4]) }

      it "beats one pair" do
        expect(two_pair_hand.beats?(one_pair_hand)).to be true
      end

      it "loses to a better high pair" do
        expect(two_pair_hand.beats?(tens_and_queens_hand)).to be false
      end
    end

    context "one pair" do
      # subject(:one_pair_hand)     { Hand.new([d4, h4, s2, s3, s7]) }
      subject(:pair_of_queens_hand) { Hand.new([sq, dq, s3, s6, s9]) }

      it "beats ace high" do
        expect(one_pair_hand.beats?(ace_high_hand)).to be true
      end

      it "loses to a higher pair" do
        expect(one_pair_hand.beats?(pair_of_queens_hand)).to be false
      end
    end

    context "high card" do
      # subject(:ace_high_hand)        { Hand.new([sa, h7, hq, s3, s5]) }
      # subject(:garbage_hand)         { Hand.new([s2, s5, s4, d7, h3]) }

      it "beats garbage" do
        expect(ace_high_hand.beats?(garbage_hand)).to be true
      end

      it "loses to a better high card" do
        expect(garbage_hand.beats?(ace_high_hand)).to be false
      end
    end
  end
end
