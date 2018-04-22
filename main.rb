require_relative 'maze_generator'

width = ARGV[0].to_i
height = ARGV[1].to_i

mazeGenerator = MazeGenerator.new(width, height, 40)
mazeGenerator.generate!
puts mazeGenerator.maze
