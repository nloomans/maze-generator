require_relative 'pos'
require_relative 'maze'

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
      print "\e[?1049h" # Save the state of the terminal
      print "\e[2J" # Clear the screen
      print "\e[0;0H" # Move the cursor to 0, 0
      print "\n   [ \e[1;35mSolving maze...\e[0m ]\n\n" # Print some nice graphics
      print "\e[s" # Save the cursor position
    end

    while @stack.last != @end_pos
      step()

      if ENV["DEBUG"] == "visual"
        print "\e[u" # Restore the cursor position
        print @maze.to_s("   ", @stack)
        print "\n\n"
        puts "   Stack size: #{@stack.length}"
      end
    end

    if ENV["DEBUG"] == "visual"
      print "\e[?1049l" # Restore the state of the terminal
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
