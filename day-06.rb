require_relative 'common'

def count_guard_positions(input)
  grid = input.map(&:chars)
  visited = Set.new

  # Find start position
  start_pos = nil
  grid.each_with_index do |row, row_idx|
    col_idx = row.index('^')
    if col_idx
      start_pos = [row_idx, col_idx]
      break
    end
  end

  find_route(visited, start_pos, grid)
  visited.size
end

def find_route(visited, start_pos, grid)
  curr_row, curr_col = start_pos
  next_row, next_col = -1, 0  # Starting direction: up

  loop do
    visited.add([curr_row, curr_col])

    # Break if guard leaves grid
    break if curr_row + next_row < 0 ||
            curr_row + next_row >= grid.length ||
            curr_col + next_col < 0 ||
            curr_col + next_col >= grid[0].length

    # Check for obstacle and turn right, or move forward
    if grid[curr_row + next_row][curr_col + next_col] == '#'
      next_col, next_row = -next_row, next_col
    else
      curr_row += next_row
      curr_col += next_col
    end
  end
end

def count_loop_positions(input)
  grid = input.map(&:chars)
  start_pos = find_start(grid)
  count = 0

  grid.each_with_index do |row, r|
    row.each_with_index do |cell, c|
      next unless cell == '.'
      next if [r, c] == start_pos

      # Test adding obstacle at this position
      grid[r][c] = '#'
      count += 1 if creates_loop?(start_pos, grid)
      grid[r][c] = '.'
    end
  end

  count
end

def creates_loop?(start_pos, grid)
  curr_row, curr_col = start_pos
  next_row, next_col = -1, 0  # Up
  visited = Set.new

  loop do
    state = [curr_row, curr_col, next_row, next_col]
    return true if visited.include?(state)
    visited.add(state)

    # Check bounds
    if curr_row + next_row < 0 || curr_row + next_row >= grid.length ||
       curr_col + next_col < 0 || curr_col + next_col >= grid[0].length
      return false
    end

    if grid[curr_row + next_row][curr_col + next_col] == '#'
      next_col, next_row = -next_row, next_col
    else
      curr_row += next_row
      curr_col += next_col
    end
  end
end

def find_start(grid)
  grid.each_with_index do |row, r|
    c = row.index('^')
    return [r, c] if c
  end
end

class Day6 < AdventDay
  def first_part
    count_guard_positions(input)
  end

  def second_part
    count_loop_positions(input)
  end

  private

  def convert_data(data)
    super
  end
end

Day6.solve
