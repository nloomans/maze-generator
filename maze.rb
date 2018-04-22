Tile = Struct.new(:pos, :up, :right, :down, :left)

class Maze
  attr_reader :width
  attr_reader :height
  attr_accessor :start_pos
  attr_accessor :end_pos

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

    [:up, :right, :down, :left].each do |dir|
      neighbors.push(pos.move(dir)) if inBounds?(pos.move(dir))
    end

    neighbors
  end

  def open_neighbors(pos)
    neighbors = []

    tile = get(pos)

    [:up, :right, :down, :left].each do |dir|
      neighbors.push(pos.move(dir)) if tile[dir] == false
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

  def to_s(prefix='', path=[])
    drawingField = Array.new(@height * 2 + 1) { Array.new(@width * 2 + 1) { " " } }

    @v_walls.each_index do |x|
      @v_walls[x].each_index do |y|
        next if @v_walls[x][y] == false

        drawingField[y * 2][x * 2] = "█"
        drawingField[y * 2 + 1][x * 2] = "█"
        drawingField[y * 2 + 2][x * 2] = "█"
      end
    end

    @h_walls.each_index do |x|
      @h_walls[x].each_index do |y|
        next if @h_walls[x][y] == false

        drawingField[y * 2][x * 2] = "█"
        drawingField[y * 2][x * 2 + 1] = "█"
        drawingField[y * 2][x * 2 + 2] = "█"
      end
    end

    bright_red_block = "\e[0;31;1m█\e[0m"

    path.each_index do |i|
      drawingField[path[i].y * 2 + 1][path[i].x * 2 + 1] = bright_red_block
      if i > 0
        wall_pos = Pos.new(path[i - 1].x * 2 + 1, path[i - 1].y * 2 + 1)
          .move(path[i].dir_from(path[i - 1]))

        drawingField[wall_pos.y][wall_pos.x] = bright_red_block
      end
    end

    drawingField.map { |line| prefix + line.join("") }.join("\n")
  end
end
