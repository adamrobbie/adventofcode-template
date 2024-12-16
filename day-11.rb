require_relative 'common'

class StoneTransformer
  def initialize(stones)
    @stones = stones
    @memo = {}
  end

  def blink(times)
    @stones.sum do |stone|
      count_stones(stone, times)
    end
  end

  private

  def count_stones(stone, blinks_left)
    memo_key = [stone, blinks_left]
    return @memo[memo_key] if @memo.key?(memo_key)

    # Base case - if no more blinks, this stone counts as 1
    if blinks_left == 0
      return 1
    end

    # Get next generation of stones based on transformation rules
    next_stones = transform_stone(stone)

    # Count stones resulting from each transformed stone
    result = next_stones.sum do |next_stone|
      count_stones(next_stone, blinks_left - 1)
    end

    @memo[memo_key] = result
  end

  def transform_stone(stone)
    if stone == 0
      [1]
    else
      digits = stone.to_s
      if digits.length.even?
        mid = digits.length / 2
        [digits[0...mid].to_i, digits[mid..-1].to_i]
      else
        [stone * 2024]
      end
    end
  end
end

class Day11 < AdventDay
  def first_part
    transformer = StoneTransformer.new(parse_input)
    transformer.blink(25)
  end

  def second_part
    transformer = StoneTransformer.new(parse_input)
    transformer.blink(75)
  end

  private

  def parse_input
    input[0].split.map(&:to_i)
  end
end

Day11.solve
