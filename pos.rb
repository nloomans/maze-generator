Pos = Struct.new(:x, :y) do
  def move(dir)
    case dir
    when :up
      Pos.new(x, y - 1)
    when :right
      Pos.new(x + 1, y)
    when :down
      Pos.new(x, y + 1)
    when :left
      Pos.new(x - 1, y)
    end
  end

  def dir_from(pos)
    diff_x = x - pos.x
    diff_y = y - pos.y

    case Pos.new(diff_x, diff_y)
    when Pos.new(0, -1)
      :up
    when Pos.new(1, 0)
      :right
    when Pos.new(0, 1)
      :down
    when Pos.new(-1, 0)
      :left
    end
  end

  def to_s()
    "(#{x}, #{y})"
  end
end
