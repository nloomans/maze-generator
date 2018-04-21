DIRS = [ :up, :right, :down, :left ]

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
end

Tile = Struct.new(:pos, :up, :right, :down, :left)

class Maze
  attr_reader :width
  attr_reader :height

  def initialize(width, height)
    @width = width
    @height = height
    @h_walls = Array.new(@width) { Array.new(@height + 1, true) }
    @v_walls = Array.new(@width + 1) { Array.new(@height, true) }
  end

  def inBounds?(pos)
    x = pos.x
    y = pos.y

    x >= 0 && y >= 0 && x < @width && y < @height
  end

  def get(pos)
    raise IndexError unless inBounds?(pos)

    x = pos.x
    y = pos.y

    Tile.new(pos, @h_walls[x][y], @v_walls[x + 1][y], @h_walls[x][y + 1], @v_walls[x][y])
  end

  def neighbors(pos)
    neighbors = []

    DIRS.each do |dir|
      neighbors.push(pos.move(dir)) if inBounds?(pos.move(dir))
    end

    neighbors
  end

  def set(pos, dir, state)
    raise IndexError if pos.x >= @width
    raise IndexError if pos.y >= @height

    case dir
    when :up
      @h_walls[pos.x][pos.y] = state
    when :right
      @v_walls[pos.x + 1][pos.y] = state
    when :down
      @h_walls[pos.x][pos.y + 1] = state
    when :left
      @v_walls[pos.x][pos.y] = state
    end
  end
end

class MazeGenerator
  def initialize(width, height)
    @maze = Maze.new(width, height)
    p @maze.width
  end


  def generate()
    @currentPos = Pos.new(Random.rand(@width), Random.rand(@height))
    @visitedCells = [@currentPos]
  end
end

# MazeGenerator.new(15, 15)
maze = Maze.new(15, 15)
p maze.neighbors(Pos.new(0,0))
