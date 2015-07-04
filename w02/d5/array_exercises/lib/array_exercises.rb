class Array
  def my_uniq
    uniqs = []
    each do |elem|
      uniqs << elem unless uniqs.include?(elem)
    end

    uniqs
  end

  def two_sum
    sums = []

    (0...(length - 1)).each do |i|
      ((i + 1)...length).each do |j|
        sums << [i, j] if self[i] + self[j] == 0
      end
    end

    sums
  end

  def median
    sorted_array = self.sort

    if length.even?
      (sorted_array[length / 2] + sorted_array[(length / 2) -1]) / 2.to_f
    else
      sorted_array[length / 2]
    end
  end

  def my_transpose
    cols = Array.new(size) { [] }

    each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        cols[col_i] << col
      end
    end

    cols
  end
end
