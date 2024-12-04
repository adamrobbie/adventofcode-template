require_relative 'common'

class Day3 < AdventDay
  def first_part
    sum_multiplications(input)
  end

  def second_part
    sum_multiplications_with_condition(input)
  end

  private

  def convert_data(data)
    super
  end

  def sum_multiplications_with_condition(data)
    # Regex to capture mul(a,b), do(), and don't() instructions
    result = 0
    enabled = true
    data.each do |line|
      instructions = line.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)

      instructions.each do |instruction|
        case instruction
        when "do()"
          enabled = true
        when "don't()"
          enabled = false
        else
          # Process mul(a,b) instructions only if enabled
          result += multiplication_result(instruction) if enabled
        end
      end

      result
    end
    result
  end

  def multiplication_result(line)
    # Regex to capture mul(a,b) instructions
    line.scan(/mul\((\d+),(\d+)\)/).map { |x, y| x.to_i * y.to_i }.sum
  end

  def sum_multiplications(data)
    data.sum do |line|
      multiplication_result(line)
    end
  end
end

Day3.solve
