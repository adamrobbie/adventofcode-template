require_relative 'common'

def validate_print_orders(input)
  # Split input into rules and updates
  rules_section, updates_section = input.join("\n").split("\n\n")

  # Parse rules into dependencies
  rules = rules_section.split("\n").map do |rule|
    before, after = rule.split("|").map(&:to_i)
    [before, after]
  end

  # Parse updates
  updates = updates_section.split("\n").map do |update|
    update.split(",").map(&:to_i)
  end

  # Find valid updates and their middle numbers
  valid_middles = updates.filter_map do |update|
    # Check each pair of pages in the update
    is_valid = update.each_with_index.all? do |page, i|
      update[i+1..].all? do |next_page|
        # If there's a rule saying next_page should come before page, order is invalid
        !rules.include?([next_page, page])
      end
    end

    # Get middle number if valid
    update[update.length / 2] if is_valid
  end

  valid_middles.sum
end

def validate_and_fix_print_orders(input)
  # Split input into rules and updates
  rules_section, updates_section = input.join("\n").split("\n\n")

  # Parse rules into dependency graph
  rules = Hash.new { |h,k| h[k] = [] }
  rules_section.split("\n").each do |rule|
    before, after = rule.split("|").map(&:to_i)
    rules[before] << after
  end

  # Parse updates
  updates = updates_section.split("\n").map do |update|
    update.split(",").map(&:to_i)
  end

  # Find invalid updates and fix them
  invalid_middles = updates.filter_map do |update|
    # Check if valid using earlier logic
    is_valid = update.each_with_index.all? do |page, i|
      update[i+1..].all? do |next_page|
        !rules_section.include?("#{next_page}|#{page}")
      end
    end

    next unless !is_valid

    # Fix ordering if invalid
    fixed = topological_sort(update, rules)
    fixed[fixed.length / 2]
  end

  invalid_middles.sum
end

def topological_sort(pages, rules)
  # Create reverse lookup of dependencies
  incoming = Hash.new { |h,k| h[k] = [] }
  pages.each do |page|
    rules.each do |before, afters|
      if afters.include?(page) && pages.include?(before)
        incoming[page] << before
      end
    end
  end

  # Find start nodes (no incoming edges)
  no_incoming = pages.select { |page| incoming[page].empty? }

  result = []
  while !no_incoming.empty?
    node = no_incoming.max # Take highest number when multiple options
    result << node
    no_incoming.delete(node)

    # Remove edges from node
    rules[node].each do |after|
      next unless pages.include?(after)
      incoming[after].delete(node)
      no_incoming << after if incoming[after].empty?
    end
  end

  result
end

class Day5 < AdventDay
  def first_part
    validate_print_orders(input)
  end

  def second_part
    validate_and_fix_print_orders(input)
  end

  private

  def convert_data(data)
    super
  end
end

Day5.solve
