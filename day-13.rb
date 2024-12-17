# claw_game.rb
class ClawGame
  Machine = Struct.new(:button_a_x, :button_a_y, :button_b_x, :button_b_y, :prize_x, :prize_y)

  def initialize(input_data)
    @machines = parse_machines(input_data)
  end

  def minimum_tokens_needed
    @machines.sum do |machine|
      solve_machine(machine) || 0
    end
  end

  private

  def parse_machines(data)
    data.join("\n").split("\n\n").map do |paragraph|
      lines = paragraph.split("\n")

      # Extract button A coordinates
      button_a = lines[0].scan(/X\+(\d+), Y\+(\d+)/).first
      ax = button_a[0].to_i
      ay = button_a[1].to_i

      # Extract button B coordinates
      button_b = lines[1].scan(/X\+(\d+), Y\+(\d+)/).first
      bx = button_b[0].to_i
      by = button_b[1].to_i

      # Extract prize coordinates
      prize = lines[2].scan(/X=(\d+), Y=(\d+)/).first
      px = prize[0].to_i
      py = prize[1].to_i

      Machine.new(ax, ay, bx, by, px, py)
    end
  end

  def solve_machine(machine)
    # Using linear algebra to solve the system of equations:
    # ax * A + bx * B = px  (equation 1)
    # ay * A + by * B = py  (equation 2)

    # Multiply equation 1 by by and equation 2 by -bx to eliminate B
    a_clicks_x = machine.button_a_x * machine.button_b_y
    a_clicks_y = -(machine.button_a_y * machine.button_b_x)
    prize_x = machine.prize_x * machine.button_b_y
    prize_y = -(machine.prize_y * machine.button_b_x)

    a_clicks_combined = a_clicks_x + a_clicks_y
    prize_combined = prize_x + prize_y

    # Check if we have an integer solution for A
    return nil if prize_combined % a_clicks_combined != 0

    a_clicks = prize_combined / a_clicks_combined
    b_clicks = (machine.prize_x - (machine.button_a_x * a_clicks)) / machine.button_b_x

    # Check if B is an integer and both A and B are non-negative
    return nil if !b_clicks.is_a?(Integer) || a_clicks < 0 || b_clicks < 0

    # Calculate total tokens needed (3 for A, 1 for B)
    a_clicks * 3 + b_clicks
  end
end

# day13.rb
require_relative 'common'

class Day13 < AdventDay
  def first_part
    game = ClawGame.new(input)
    game.minimum_tokens_needed
  end

  def second_part
  end

  private

  def convert_data(data)
    super
  end
end

Day13.solve
