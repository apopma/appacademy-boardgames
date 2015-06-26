class Array
  def my_each(&block)
    self.length.times { |idx| block.call(self[idx]) }
    self
  end

  def my_map(&block)
    new_arr = []

    self.my_each do |el|
      new_arr << block.call(el)
    end

    new_arr
  end

  def my_select(&block)
    selection = []
    self.each do |el|
      selection << el if block.call(el) == true
    end
    selection
  end

  def my_inject(&block) #first elem is always accumulator
    result = self.first
    my_arr = self.drop(1)

    my_arr.length.times do |idx|
      result = block.call(result, my_arr[idx])
    end

    result
  end

  # ----------------------------------------------------------------------------

  def my_sort(&block)
    return self if self.length < 2
    arr = self.shuffle
    pivot = arr.first

    left, right = [], []

    arr.drop(1).each do |el|
      if block.call(pivot, el) == -1
        right << el
      else
        left << el
      end
    end
    left.my_sort!(&block) + [pivot] + right.my_sort!(&block)
  end

  def my_sort!(&block)
    self.replace( my_sort(&block))
  end

  def my_sort_duping(&block) #jeff
    self.dup.my_sort!(&block)
  end
end

# ------------------------------------------------------------------------------

def eval_block(*args, &block)
  debugger
  return "NO BLOCK GIVEN!" unless block_given?
  block.call(*args)
end
