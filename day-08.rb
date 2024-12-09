require_relative 'common'

class AntennaMap
  def initialize(input)
    @grid = input.map(&:chars)
    @height = @grid.length
    @width = @grid[0].length
  end

  def count_antinodes
    antinodes = Set.new
    frequencies = find_frequencies

    frequencies.each do |freq, positions|
      positions.combination(2).each do |pos1, pos2|
        add_antinodes(antinodes, pos1, pos2)
      end
    end

    antinodes.size
  end

  def count_collinear_antinodes
    antinodes = Set.new
    frequencies = find_frequencies

    frequencies.each do |freq, positions|
      next if freq == '.'
      positions.combination(2).each do |pos1, pos2|
        add_collinear_antinodes(antinodes, pos1, pos2)
      end
    end

    antinodes.size
  end

  private

  def find_frequencies
    frequencies = Hash.new { |h, k| h[k] = [] }

    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        frequencies[cell] << [x, y] unless cell == '.'
      end
    end

    frequencies
  end

  def add_antinodes(antinodes, pos1, pos2)
    x1, y1 = pos1
    x2, y2 = pos2

    # Calculate distance between points
    dx = x2 - x1
    dy = y2 - y1
    dist = dx * dx + dy * dy

    # For each point, check if other is twice the distance
    [[pos1, pos2], [pos2, pos1]].each do |center, other|
      cx, cy = center
      ox, oy = other

      # Calculate antinode position at twice the distance
      antinode_x = cx + 2 * (ox - cx)
      antinode_y = cy + 2 * (oy - cy)

      # Add if within bounds
      if in_bounds?(antinode_x, antinode_y)
        antinodes.add([antinode_x, antinode_y])
      end
    end
  end

  def add_collinear_antinodes(antinodes, pos1, pos2)
    x1, y1 = pos1
    x2, y2 = pos2

    # Calculate vector components
    dx = x2 - x1
    dy = y2 - y1

    # Check every point in grid
    @height.times do |y|
      @width.times do |x|
        # Skip if out of bounds
        next unless in_bounds?(x, y)

        # Check if point is collinear with the two antennas
        # Cross product should be 0 for collinear points
        cross_product = (x - x1) * (y2 - y1) - (y - y1) * (x2 - x1)

        # Check if point is between or on same line as antennas
        if cross_product == 0
          antinodes.add([x, y])
        end
      end
    end
  end

  def add_if_in_bounds(antinodes, x, y)
    antinodes.add([x, y]) if in_bounds?(x, y)
  end

  def in_bounds?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end
end

class Day8 < AdventDay
  def first_part
    AntennaMap.new(input).count_antinodes
  end

  def second_part
    AntennaMap.new(input).count_collinear_antinodes
  end

  private

  def convert_data(data)
    super
  end
end

Day8.solve
