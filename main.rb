require_relative './pos.rb'
require_relative './maze.rb'

class MazeGenerator
  attr_reader :maze

  def initialize(width, height)
    @maze = Maze.new(width, height)
  end

  def generate()
    @visitedCells = [@currentPos]
    @stack = [Pos.new(0, 0)]

    while !@stack.empty?
      step()
    end
  end

  def step()
    neighbors = @maze.neighbors(@stack.last)
    neighbors.select! do |neighbor|
      !@visitedCells.include? neighbor
    end

    if neighbors.empty?
      @stack.pop()
    else
      randomNeighbor = neighbors.sample
      print "Removing wall between ", @stack.last, " and ", randomNeighbor, "\n"
      @maze.set(@stack.last, randomNeighbor.dir_from(@stack.last), false)

      @stack.push(randomNeighbor)
      @visitedCells.push(randomNeighbor)
    end
  end
end

mazeGenerator = MazeGenerator.new(118, 30)
mazeGenerator.generate
puts mazeGenerator.maze
