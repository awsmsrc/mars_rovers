class Grid
  def initialize(x, y)
    @x, @y = x, y
  end

  def valid_pos?(x,y)
    x >= 0 and y >= 0 and x <= @x and y <= @y
  end
end
