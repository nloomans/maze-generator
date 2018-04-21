require_relative './pos.rb'
require_relative './maze.rb'

class MazeGenerator
  attr_reader :maze

  def initialize(width, height)
    @maze = Maze.new(width, height)
    @visitedTiles = Array.new(width) { Array.new(height) { false } }
  end

  def generate()
    @visitedCells = [@currentPos]
    @stack = [Pos.new(rand(@maze.width), rand(@maze.height))]

    while !@stack.empty?
      step()
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
      print "Removing wall between ", @stack.last, " and ", randomNeighbor, "\n"
      @maze.set(@stack.last, randomNeighbor.dir_from(@stack.last), false)

      @stack.push(randomNeighbor)
      @visitedTiles[randomNeighbor.x][randomNeighbor.y] = true
    end
  end
end

mazeGenerator = MazeGenerator.new(118, 30)
mazeGenerator.generate
puts mazeGenerator.maze
