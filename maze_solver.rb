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
    while @stack.last != @end_pos
      step()
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
    else
      randomNeighbor = neighbors.sample
      @stack.push(randomNeighbor)
      @visitedTiles[randomNeighbor.x][randomNeighbor.y] = true
    end
  end
end
