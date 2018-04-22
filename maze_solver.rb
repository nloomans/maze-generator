require_relative 'pos'
require_relative 'maze'
require_relative 'tui'

class MazeSolver
  attr_reader :maze
  attr_reader :stack

  def initialize(maze, start_pos, end_pos)
    @maze = maze
    @start_pos = start_pos
    @end_pos = end_pos
    @stack = [start_pos]
    @visitedTiles = Array.new(@maze.width) { Array.new(@maze.height) { false } }
  end

  def solve!()
    if ENV["DEBUG"] == "visual"
      TUI::Screen.save
      TUI::Screen.reset
      puts
      puts "   [ #{TUI::Color.magenta}Solving maze...#{TUI::Color.reset} ]"
      puts
      TUI::Cursor.save
    end

    while @stack.last != @end_pos
      step()

      if ENV["DEBUG"] == "visual"
        TUI::Cursor.restore
        puts @maze.to_s("   ", @stack)
        puts
        puts "   Stack size: #{@stack.length}"
        puts "   Current algorithm: Depth-first search"
      end
    end

    if ENV["DEBUG"] == "visual"
      TUI::Screen.restore
    end
  end

  def step()
    current_tile = @stack.last

    neighbors = @maze.open_neighbors(current_tile)
    neighbors.select! do |neighbor|
      @visitedTiles[neighbor.x][neighbor.y] == false
    end

    if neighbors.empty?
      @stack.pop()
      puts "Popping to #{stack.last}" if ENV["DEBUG"] == "log"
    else
      randomNeighbor = neighbors.sample
      @stack.push(randomNeighbor)
      puts "Pushing to #{stack.last}" if ENV["DEBUG"] == "log"
      @visitedTiles[randomNeighbor.x][randomNeighbor.y] = true
    end
  end
end
