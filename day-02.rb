require_relative 'common'

class Day2 < AdventDay
  def first_part
    count_safe_reports(input)
  end

  def second_part
    count_safe_reports_with_dampener(input)
  end

  private

  def convert_data(data)
    super
  end

  def count_safe_reports(data)
    data.count do |line|
      levels = line.split.map(&:to_i)
      differences = levels.each_cons(2).map { |a, b| b - a }

      # Check if all differences are in same direction and within range
      all_increasing = differences.all? { |d| d.between?(1, 3) }
      all_decreasing = differences.all? { |d| d.between?(-3, -1) }

      all_increasing || all_decreasing
    end
  end

  def count_safe_reports_with_dampener(data)
    data.count do |line|
      levels = line.split.map(&:to_i)

      # Check if safe without dampener
      next true if is_safe?(levels)

      # Try removing each level to see if it makes the sequence safe
      (0...levels.length).any? do |i|
        dampened_levels = levels[0...i] + levels[i + 1..]
        is_safe?(dampened_levels)
      end
    end
  end

  def is_safe?(levels)
    return true if levels.length <= 1

    differences = levels.each_cons(2).map { |a, b| b - a }
    differences.all? { |d| d.between?(1, 3) } ||
      differences.all? { |d| d.between?(-3, -1) }
  end
end

Day2.solve
