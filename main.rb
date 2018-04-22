require_relative 'maze_generator'
require_relative 'maze_solver'
require_relative 'pos'

width = ARGV[0].to_i
height = ARGV[1].to_i

maze_generator = MazeGenerator.new(width, height, 10000000)
maze_generator.generate!

maze = maze_generator.maze

maze_solver = MazeSolver.new(maze, Pos.new(0, 0), Pos.new(width - 1, height - 1))
maze_solver.solve!
puts maze.to_s('', maze_solver.stack)
