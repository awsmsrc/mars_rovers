require_relative '../../lib/grid.rb'

describe Grid do
  subject { Grid.new(5,5) }

  describe "#valid_pos?" do
    context "with valid coords" do
      specify { subject.valid_pos?(3,3).should be == true }
    end
    context "with invalid coords" do
      specify { subject.valid_pos?(6,6).should be == false }
      specify { subject.valid_pos?(-1,-1).should be == false }
    end
  end

end
