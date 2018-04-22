require_relative 'pos'
require_relative 'maze'

class MazeGenerator
  attr_reader :maze

  def initialize(width, height)
    @maze = Maze.new(width, height)
    @visitedTiles = Array.new(width) { Array.new(height) { false } }
  end

  def generate!()
    @visitedCells = [@currentPos]
    @stack = [Pos.new(rand(@maze.width), rand(@maze.height))]

    if ENV["DEBUG"] == "visual"
      print "\e[?1049h" # Save the state of the terminal
      print "\e[2J" # Clear the screen
      print "\e[0;0H" # Move the cursor to 0, 0
      print "\n   [ \e[1;35mGenerating maze...\e[0m ]\n\n" # Print some nice graphics
      print "\e[s" # Save the cursor position
    end

    print "\e[s" if ENV["DEBUG"] == "visual"

    while !@stack.empty?
      step()
      if ENV["DEBUG"] == "visual"
        print "\e[u" # Restore the cursor position
        print @maze.to_s("   ")
      end
    end

    if ENV["DEBUG"] == "visual"
      print "\e[?1049l" # Restore the state of the terminal
    end
  end

  def step()
    neighbors = @maze.neighbors(@stack.last)
    neighbors.select! do |neighbor|
      @visitedTiles[neighbor.x][neighbor.y] == false
    end

    if neighbors.empty?
      @stack.pop()
    else
      randomNeighbor = neighbors.sample
      print "Removing wall between ", @stack.last, " and ", randomNeighbor, "\n" if ENV["DEBUG"] == "log"
      @maze.set(@stack.last, randomNeighbor.dir_from(@stack.last), false)

      @stack.push(randomNeighbor)
      @visitedTiles[randomNeighbor.x][randomNeighbor.y] = true
    end
  end
end
