require 'array_exercises'
require 'rspec'

describe Array do
  describe "#my_uniq" do
    subject(:test) { [1, 2, 1, 3, 3] }

    it "returns the uniq elements in the order in which they appear" do
      expect(test.my_uniq).to eq([1, 2, 3])
    end

    it "returns the duplicate if everything is unique" do
      expect([1, 2, 3].my_uniq).to eq([1, 2, 3])
    end
  end

  describe "#two_sum" do
    subject(:test) { [-1, 0, 2, -2, 1] }
    let(:wrong_answer) { [[2, 3], [0, 4]] }

    it "returns the indices of the pairs of elements that add to zero" do
      expect(test.two_sum).to eq([[0, 4], [2, 3]])
    end

    it "returns elements sorted dictionary-wise" do
      expect(test.two_sum).to eq(wrong_answer.sort)
    end
  end

  describe "#median" do
    context "for an array of odd size" do
      subject(:sorted) { [1, 2, 3, 4, 5] }
      subject(:unsorted) { [3, 1, 2, 5, 4] }

      it "returns the middle item" do
        expect(sorted.median).to eq(3)
      end

      it "looks at the sorted array" do
        expect(unsorted.median).to eq(3)
      end
    end

    context "for an array of even size" do
      subject(:sorted) { [1, 2, 3, 4, 5, 6] }
      subject(:unsorted) { [3, 6, 2, 1, 5, 4] }

      it "returns the average of the two middle items" do
        expect(sorted.median).to be_within(0.1).of(3.5)
      end

      it "also looks at the sorted array" do
        expect(unsorted.median).to be_within(0.1).of(3.5)
      end
    end
  end

  describe "#my_transpose" do
    subject(:rows) {[
      [0, 1, 2], [3, 4, 5], [6, 7, 8]
      ]}

    it "converts rows and columns" do
      expect(rows.my_transpose).to eq ([
        [0, 3, 6], [1, 4, 7], [2, 5, 8]
        ])
    end

    it "doesn't call the existing Array#transpose method" do
      expect(rows).not_to receive(:transpose)
      rows.my_transpose
    end
  end
end
