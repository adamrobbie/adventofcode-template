require_relative 'common'

class Day4 < AdventDay
  def first_part
    searcher = XmasSearch.new(input)
    result = searcher.find_xmas
  end

  def second_part
    searcher = XmasSearch.new(input)
    result = searcher.find_x_mas
  end

  private

  def convert_data(data)
    super
  end
end

class XmasSearch
  XMAS = "XMAS"
  VALID_X_PATTERNS = ["MMSS", "SSMM", "MSMS", "SMSM"]

  def initialize(input)
    @grid = input
    @height = @grid.size
    @width = @grid[0].size
  end

  # Part 1: Find all XMAS occurrences in any direction
  def find_xmas
    matches = []
    @height.times do |row|
      @width.times do |col|
        if @grid[row][col] == "X"
          [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |dy, dx|
            if check_word_in_direction(row, col, dy, dx, XMAS)
              matches << [row, col, dy, dx]
            end
          end
        end
      end
    end
    matches.size
  end

  # Part 2: Find X-shaped MAS patterns
  def find_x_mas
    count = 0
    # Start from 1 and end before the last row/col to ensure we can check corners
    (1...@height-1).each do |row|
      (1...@width-1).each do |col|
        count += 1 if is_x_mas?(row, col)
      end
    end
    count
  end

  private

  def is_x_mas?(row, col)
    return false unless @grid[row][col] == "A"

    # Get the four corners around the A
    corner_chars = [
      @grid[row-1][col-1], # top-left
      @grid[row-1][col+1], # top-right
      @grid[row+1][col-1], # bottom-left
      @grid[row+1][col+1]  # bottom-right
    ].join

    VALID_X_PATTERNS.include?(corner_chars)
  end

  def check_word_in_direction(row, col, dy, dx, word)
    # Check bounds
    end_row = row + (dy * (word.length - 1))
    end_col = col + (dx * (word.length - 1))
    return false unless end_row.between?(0, @height - 1) && end_col.between?(0, @width - 1)

    # Check each character
    word.each_char.with_index do |char, i|
      y = row + (dy * i)
      x = col + (dx * i)
      return false unless @grid[y][x] == char
    end

    true
  end
end

Day4.solve
