require_relative 'maze_generator'

mazeGenerator = MazeGenerator.new(ARGV[0].to_i, ARGV[1].to_i)
mazeGenerator.generate
puts mazeGenerator.maze
