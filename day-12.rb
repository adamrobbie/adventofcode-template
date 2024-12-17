# garden_map.rb
class GardenMap
  def initialize(data)
    @data = data.map { |row| row.chars }
    @height = data.size
    @width = data[0].size
    @visited = Array.new(@height) { Array.new(@width, false) }
  end

  def total_fencing_price
    reset_visited
    total = 0

    @height.times do |i|
      @width.times do |j|
        next if @visited[i][j]
        total += process_region(i, j)
      end
    end

    total
  end

  def total_fencing_price_with_sides
    reset_visited
    total = 0

    @height.times do |i|
      @width.times do |j|
        next if @visited[i][j]
        total += process_region_with_sides(i, j)
      end
    end

    total
  end

  private

  def reset_visited
    @visited.each { |row| row.fill(false) }
  end

  def process_region(start_i, start_j)
    area = 0
    perimeter = 0
    plant = @data[start_i][start_j]
    stack = [[start_i, start_j]]

    while !stack.empty?
      i, j = stack.pop
      next if @visited[i][j]

      @visited[i][j] = true
      area += 1

      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |(di, dj)|
        ni, nj = i + di, j + dj

        if out_of_bounds?(ni, nj) || @data[ni][nj] != plant
          perimeter += 1
        elsif !@visited[ni][nj]
          stack.push([ni, nj])
        end
      end
    end

    area * perimeter
  end

  def process_region_with_sides(start_i, start_j)
    area = 0
    plant = @data[start_i][start_j]
    stack = [[start_i, start_j]]

    # Track border plots by direction
    top_borders = {}    # by row
    bottom_borders = {} # by row
    left_borders = {}   # by col
    right_borders = {}  # by col

    while !stack.empty?
      i, j = stack.pop
      next if @visited[i][j]

      @visited[i][j] = true
      area += 1

      # Check all four directions
      check_neighbor(i, j, -1, 0, plant, top_borders, i, j)    # top
      check_neighbor(i, j, 1, 0, plant, bottom_borders, i, j)  # bottom
      check_neighbor(i, j, 0, -1, plant, left_borders, j, i)   # left
      check_neighbor(i, j, 0, 1, plant, right_borders, j, i)   # right

      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |(di, dj)|
        ni, nj = i + di, j + dj
        next if out_of_bounds?(ni, nj) || @visited[ni][nj] || @data[ni][nj] != plant
        stack.push([ni, nj])
      end
    end

    sides = count_sides(top_borders) + count_sides(bottom_borders) +
           count_sides(left_borders) + count_sides(right_borders)

    area * sides
  end

  def check_neighbor(i, j, di, dj, plant, borders, key, val)
    ni, nj = i + di, j + dj
    if out_of_bounds?(ni, nj) || @data[ni][nj] != plant
      borders[key] ||= []
      borders[key] << val
    end
  end

  def count_sides(borders)
    borders.values.sum do |coords|
      # Sort coordinates and remove consecutive numbers
      coords.sort.chunk_while { |a, b| b - a == 1 }.count
    end
  end

  def out_of_bounds?(i, j)
    i < 0 || i >= @height || j < 0 || j >= @width
  end
end

# day12.rb
require_relative 'common'

class Day12 < AdventDay
  def first_part
    garden = GardenMap.new(input)
    garden.total_fencing_price
  end

  def second_part
    garden = GardenMap.new(input)
    garden.total_fencing_price_with_sides
  end

  private

  def convert_data(data)
    super
  end
end

Day12.solve
