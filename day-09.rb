require_relative 'common'

class DiskFragmenter
  def initialize(disk_map)
    @disk_map = disk_map.chars.map(&:to_i)
    @files = build_initial_disk
  end

  def compact_and_checksum
    sort_from_index(@disk_map[0])
    calculate_checksum
  end

  def compact_whole_files_and_checksum
     max_id = @files.max
     start_idx = @disk_map[0]

     max_id.downto(1) do |id|
       move_file(id, start_idx)
     end

     calculate_checksum
   end

  private

  def build_initial_disk
    files = []
    file_id = 0

    @disk_map.each_with_index do |size, i|
      if i.even?
        size.times { files << file_id }
        file_id += 1
      else
        size.times { files << 0 }
      end
    end
    files
  end

  def move_file(id, start_idx)
    # Find file boundaries
    file_start = file_end = -1
    @files.each_with_index do |f, i|
      if f == id
        file_start = i if file_start == -1
        file_end = i
      end
    end
    return if file_start == -1

    file_length = file_end - file_start + 1

    # Find leftmost valid space
    space_start = -1
    space_length = 0
    (start_idx...file_start).each do |i|
      if @files[i] == 0
        space_start = i if space_start == -1
        space_length += 1
      else
        space_start = -1
        space_length = 0
      end
      break if space_length >= file_length
    end

    # Move file if valid space found
    if space_start != -1 && space_length >= file_length
      file_length.times do |i|
        @files[space_start + i] = id
        @files[file_start + i] = 0
      end
    end
  end

  def sort_from_index(start_idx)
    left = start_idx
    right = @files.length - 1

    while left < right
      while left < right && @files[left] != 0
        left += 1
      end
      while left < right && @files[right] == 0
        right -= 1
      end
      if left < right
        @files[left], @files[right] = @files[right], @files[left]
      end
    end
  end

  def calculate_checksum
    @files.each_with_index.sum { |id, pos| id * pos }
  end
end

class Day9 < AdventDay
  def first_part
     DiskFragmenter.new(input[0]).compact_and_checksum
  end

  def second_part
    DiskFragmenter.new(input[0]).compact_whole_files_and_checksum
  end

  private

  def convert_data(data)
    super
  end
end

Day9.solve
