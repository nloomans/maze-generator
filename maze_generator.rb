require_relative 'pos'
require_relative 'maze'

class MazeGenerator
  attr_reader :maze

  def initialize(width, height, stack_threshold = nil)
    @maze = Maze.new(width, height)

    @stack_threshold = if stack_threshold
      stack_threshold
    else
      width * height
    end

    @visitedTiles = Array.new(width) { Array.new(height) { false } }
  end

  def current_algorithm
    if @stack.length < @stack_threshold
      :dfs
    else
      :bfs
    end
  end

  def generate!()
    start_pos = Pos.new(rand(@maze.width), rand(@maze.height))
    @visitedTiles[start_pos.x][start_pos.y] = true
    @stack = [start_pos]

    if ENV["DEBUG"] == "visual"
      TUI::Screen.save
      TUI::Screen.reset
      puts
      puts "   [ #{TUI::Color.magenta}Generating maze...#{TUI::Color.reset} ]"
      puts
      TUI::Cursor.save
    end

    while !@stack.empty?
      step()

      if ENV["DEBUG"] == "visual"
        TUI::Cursor.restore
        puts @maze.to_s("   ")
        puts
        TUI::Screen.reset_line
        puts "   Stack size: #{@stack.length}"
        puts "   Current algorithm: #{current_algorithm}"
      end
    end

    if ENV["DEBUG"] == "visual"
      TUI::Screen.restore
    end
  end

  def step()
    current_tile = case current_algorithm
      when :dfs then @stack.last
      when :bfs then @stack.first
    end

    neighbors = @maze.neighbors(current_tile)
    neighbors.select! do |neighbor|
      @visitedTiles[neighbor.x][neighbor.y] == false
    end

    if neighbors.empty?
      case current_algorithm
        when :dfs then @stack.pop()
        when :bfs then @stack.shift()
      end
    else
      randomNeighbor = neighbors.sample
      print "Removing wall between ", current_tile, " and ", randomNeighbor, "\n" if ENV["DEBUG"] == "log"
      @maze.set(current_tile, randomNeighbor.dir_from(current_tile), false)

      @stack.push(randomNeighbor)
      @visitedTiles[randomNeighbor.x][randomNeighbor.y] = true
    end
  end
end
