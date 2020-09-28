require "./lib/grid.rb"
require "./lib/slot.rb"
require "./lib/output.rb"

YELLOW_DISC = "\u{1F7E1}"
RED_DISC = "\u{1F534}"

describe Grid do
  context "when a new grid is instantiated" do
    subject {described_class.new}

    it "has 7 columns" do
      expect(subject.columns.length).to be(7)
    end

    it "each column has a depth of 6 slots" do
      subject.columns.each { |column| expect(column.length).to be(6) }
    end
  end

  describe "#full?" do
    context "when all of the slots within the grid are taken" do
      subject {described_class.new}
      
      it "#full? returns true" do 
        subject.slots.each do |slot| 
          allow(slot).to receive(:taken?).and_return(true) 
        end
        expect(subject.full?).to be true
      end
    end
  end

  describe "#column_full?" do
    context "when all of the slots within a column are taken" do
      subject {described_class.new}

      it "#column_full? returns true" do
        subject.columns[0].each do |slot|
          allow(slot).to receive(:taken?).and_return(true)
        end
        expect(subject.column_full?(0)).to be true
      end
    end
  end

  describe "#winner?" do
    context "when four slots in a row are filled with discs of the same color" do 
      subject {described_class.new}
    
      it "returns the color of the discs in question" do 
        for i in 0..3
          subject.columns[i][2].value = RED_DISC
        end
        expect(subject.winner?).to eql(RED_DISC)
      end
    end

    context "when four slots in a column are filled with discs of the same color" do
      subject {described_class.new}
      
      it "returns the color of the discs in question" do
        for i in 0..3
          subject.columns[2][i].value = YELLOW_DISC
        end
        expect(subject.winner?).to eql(YELLOW_DISC)
      end
    end

    context "when four slots in a diagonal line (positive slope) are filled with discs of the same color" do
      subject {described_class.new} 

      it "returns the color of the discs in question" do
        for i in 0..3
          subject.columns[i][i].value  = RED_DISC
        end
        expect(subject.winner?).to eql(RED_DISC)
      end
    end

    context "when four slots in a diagonal line (negative slope) are filled with discs of the same color" do
      subject {described_class.new} 

      it "returns the color of the discs in question" do
        i = 0
        for x in 0..3
          subject.columns[x][5 - i].value  = RED_DISC
          i +=1
        end
        expect(subject.winner?).to eql(RED_DISC)
      end
    end
  end
end

describe Slot do
  context "when a new slot is instantiated" do
    subject {described_class.new}

    it "has an initial value of nil" do
      expect(subject.value).to eql(nil)
    end
  end

  describe "#taken?" do
    subject {described_class.new}
    
    context "when initialized" do  
      it "will return false because it is an empty slot" do
        expect(subject.taken?).to eql(false)
      end
    end

    context "after inserting a disc" do
      it "will return true" do
        subject.insert_disc(RED_DISC)
        expect(subject.taken?).to eql(true)
      end
    end

  end

  describe "#insert_disc" do
    subject {described_class.new}

    it "takes on the value of the disk" do
      subject.insert_disc(RED_DISC)
      expect(subject.value).to eql(RED_DISC)
    end
  end
end