require_relative '../../lib/rover.rb'

describe Rover do
  let(:grid) { double }  

  describe "#initialize" do
    context "with an invalid landing zone" do
      let(:grid) { double.tap { |g| g.stub(:valid_pos?) { false } } }
      subject { Rover.new(grid, 10, 10, 'N')  }
      it "crash lands" do
        expect { subject }.to raise_error(OutOfRangeError)
      end
    end
  end

  describe "#command!" do
    context 'with valid commands' do
      before { grid.stub(:valid_pos?) { true } }
      context 'when facing north' do
        subject { Rover.new(grid, 0, 0, 'N') }

        it "should turn left" do
          expect { subject.command!('L') }.to change { subject.bearing }.from('N').to('W')
        end

        it "should turn right" do
          expect { subject.command!('R') }.to change { subject.bearing }.from('N').to('E')
        end

        it "should move forwards" do
          expect { subject.command!('M') }.to change { subject.y }.from(0).to(1)
        end
      end

      context 'when facing east' do
        subject { Rover.new(grid, 0, 0, 'E') }

        it "should turn left" do
          expect { subject.command!('L') }.to change { subject.bearing }.from('E').to('N')
        end

        it "should turn right" do
          expect { subject.command!('R') }.to change { subject.bearing }.from('E').to('S')
        end

        it "should move forwards" do
          expect { subject.command!('M') }.to change { subject.x }.from(0).to(1)
        end
      end

      context 'when facing south' do
        subject { Rover.new(grid, 0, 1, 'S') }

        it "should turn left" do
          expect { subject.command!('L') }.to change { subject.bearing }.from('S').to('E')
        end

        it "should turn right" do
          expect { subject.command!('R') }.to change { subject.bearing }.from('S').to('W')
        end

        it "should move forwards" do
          expect { subject.command!('M') }.to change { subject.y }.from(1).to(0)
        end
      end

      context 'When Facing West' do
        subject { Rover.new(grid, 1, 0, 'W') }

        it "should turn left" do
          expect { subject.command!('L') }.to change { subject.bearing }.from('W').to('S')
        end

        it "should turn Right" do
          expect { subject.command!('R') }.to change { subject.bearing }.from('W').to('N')
        end

        it "should move forwards" do
          expect { subject.command!('M') }.to change { subject.x }.from(1).to(0)
        end
      end

      context "with obstacles" do
        subject { Rover.new(grid, 0, 0, 'N') }
        let!(:obstacle) { double.tap {|r| r.stub(:coords) { {x:0,y:1} } } }
        it "alerts of a collisoin" do
          expect { subject.command!('M', [obstacle]) }.to raise_error(CollisionDidOccurError)
        end
      end

      context "with invalid commands" do
        before { grid.stub(:valid_pos?) { false } }
        subject { Rover.new(grid, 0, 0, 'N') }
        it "should not stray from the grid" do
          expect { subject.command!('M') }.to raise_error(OutOfRangeError)
        end
      end
    end
  end
end

