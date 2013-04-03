class OutOfRangeError < StandardError;end
class InvalidInstructionError < StandardError;end
class CollisionDidOccurError < StandardError;end

class Rover

  attr_reader :grid, :x, :y, :bearing

  def initialize(grid, x, y, bearing)
    raise OutOfRangeError unless grid.valid_pos?(x, y)
    @grid, @x, @y, @bearing = grid, x, y, bearing
  end

  def command!(instruction, others = nil)
    raise InvalidInstructionError unless valid_commands.include?(instruction)
    self.send("#{instruction.downcase}!") 
    detect_collisions!(others) if others
  end

  def state
    "#{x} #{y} #{bearing}"
  end

  def coords
    {x:x,y:y}
  end

  private

  def detect_collisions!(others)
    locations = others.map(&:coords)
    raise CollisionDidOccurError if locations.include?(coords)
  end

  def valid_commands
    %w(M L R)
  end

  def available_bearings
    %w(N E S W)
  end

  def m!
    case bearing
    when 'N'
      raise OutOfRangeError unless grid.valid_pos?(x, y + 1)
      @y = y + 1 
    when 'E'
      raise OutOfRangeError unless grid.valid_pos?(x + 1, y)
      @x = x + 1 
    when 'S'
      raise OutOfRangeError unless grid.valid_pos?(x, y - 1)
      @y = y - 1 
    when 'W'
      raise OutOfRangeError unless grid.valid_pos?(x - 1, y)
      @x = x - 1 
    end
  end

  def l!
    index = available_bearings.index(bearing)
    @bearing = available_bearings[index - 1]
  end

  def r!
    index = available_bearings.index(bearing)
    index = -1 if index == (available_bearings.length - 1)
    @bearing = available_bearings[index + 1]
  end
end
