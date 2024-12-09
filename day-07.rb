require_relative 'common'

def calculate_calibration(input)
  input.sum do |line|
    test_value, numbers = parse_line(line)
    operators = ['+', '*']
    combinations = generate_operator_combinations(numbers.length - 1, operators)

    combinations.any? { |ops| evaluate(numbers, ops) == test_value } ? test_value : 0
  end
end

def parse_line(line)
  test_value, numbers = line.split(': ')
  [test_value.to_i, numbers.split.map(&:to_i)]
end

def generate_operator_combinations(length, operators)
   operators.product(*([operators] * (length - 1)))
 end

def evaluate(numbers, operators)
  result = numbers[0]
  operators.each_with_index do |op, i|
    result = op == '+' ? result + numbers[i + 1] : result * numbers[i + 1]
  end
  result
end

  def calculate_bridge_calibration(input)
    input.sum do |line|
      test_value, numbers = parse_line(line)
      operators = ['+', '*', '||']
      combinations = generate_operator_combinations(numbers.length - 1, operators)
      combinations.any? { |ops| evaluate_multiple_operators(numbers, ops) == test_value } ? test_value : 0
    end
  end

  def evaluate_multiple_operators(numbers, operators)
    result = numbers[0]
    operators.each_with_index do |op, i|
      case op
      when '+'
        result += numbers[i + 1]
      when '*'
        result *= numbers[i + 1]
      when '||'
        result = (result.to_s + numbers[i + 1].to_s).to_i
      end
    end
    result
  end

class Day7 < AdventDay
  def first_part
     calculate_calibration(input)
  end

  def second_part
    calculate_bridge_calibration(input)
  end

  private

  def convert_data(data)
    super
  end
end

Day7.solve
