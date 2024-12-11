require_relative 'common'

class HikingTrailCalculator
  def initialize(map)
    @map = map.map { |row| row.chars.map(&:to_i) }
    @height = @map.length
    @width = @map[0].length
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end

  def sum_trailhead_scores
    find_trailheads.sum { |x, y| calculate_score(x, y) }
  end

  private

  def find_trailheads
    trailheads = []
    @height.times do |y|
      @width.times do |x|
        trailheads << [x, y] if @map[y][x] == 0
      end
    end
    trailheads
  end

  def calculate_score(start_x, start_y)
    reachable = Set.new
    visited = Set.new
    explore(start_x, start_y, visited, reachable)
    reachable.count { |x, y| @map[y][x] == 9 }
  end

  def explore(x, y, visited, reachable)
    current_height = @map[y][x]
    @directions.each do |dx, dy|
      next_x, next_y = x + dx, y + dy
      next unless in_bounds?(next_x, next_y)
      next if visited.include?([next_x, next_y])

      next_height = @map[next_y][next_x]
      if next_height == current_height + 1
        reachable.add([next_x, next_y])
        visited.add([next_x, next_y])
        explore(next_x, next_y, visited, reachable)
      end
    end
  end

  def in_bounds?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end
end

class Day10 < AdventDay
  def first_part
    HikingTrailCalculator.new(input).sum_trailhead_scores
  end

  def second_part
  end

  private

  def convert_data(data)
    super
  end
end

Day10.solve
