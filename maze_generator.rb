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

  def generate!()
    start_pos = Pos.new(rand(@maze.width), rand(@maze.height))
    @visitedTiles[start_pos.x][start_pos.y] = true
    @stack = [start_pos]

    if ENV["DEBUG"] == "visual"
      TUI::Screen.save
      TUI::Screen.reset
      print "\n   [ #{TUI::Color.purple}Generating maze...#{TUI::Color.reset} ]\n\n"
      TUI::Cursor.save
    end

    while !@stack.empty?
      step()

      if ENV["DEBUG"] == "visual"
        TUI::Cursor.restore
        print @maze.to_s("   ")
        print "\n\n"
        puts "   Stack size: #{@stack.length}"
        if @stack.length < @stack_threshold
          puts "   Current algorithm: Depth-first search"
        else
          puts "   Current algorithm: Breath-first search"
        end
      end
    end

    if ENV["DEBUG"] == "visual"
      TUI::Screen.restore
    end
  end

  def step()
    current_tile =  if @stack.length < @stack_threshold
      @stack.last
    else
      @stack.first
    end

    neighbors = @maze.neighbors(current_tile)
    neighbors.select! do |neighbor|
      @visitedTiles[neighbor.x][neighbor.y] == false
    end

    if neighbors.empty?
      if @stack.length < @stack_threshold
        @stack.pop()
      else
        @stack.shift()
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
