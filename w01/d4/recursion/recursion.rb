require 'byebug'

def range_recursive(starting, ending)
  return [] if ending < starting
  result = []
  result << starting
  result += range_recursive(starting + 1, ending)
end

def range_iterative(start, ending)
  i = start
  result = []
  while i <= ending
    result << i
    i += 1
  end
  result
end

# ---------------------------------------------------------------

def exp_1(num, pow)
  return 1 if pow == 0

  num * exp_1(num, pow - 1)
end

def exp_2(num, pow)
  return 1 if pow == 0
  return num if pow == 1

  if pow.even?
     new_exp = exp_2(num, (pow / 2))
     new_exp * new_exp
  else
    new_exp = exp_2(num, ((pow - 1) / 2))
    new_exp *= new_exp
    num * new_exp
  end
end

# ---------------------------------------------------------------

class Array
  def deep_dup
    result = []
    self.each do |el|
      el.is_a?(Array) ? result << el.deep_dup : result << el
    end
    result
  end
end

# ---------------------------------------------------------------

def fibo_recursive(n)
  return [1] if n == 1 || n == 0
  return [1, 1] if n == 2

  last_fibo = fibo_recursive(n - 1)
  last_fibo << (last_fibo[-1] + last_fibo[-2])
  last_fibo
end


def fibo_iterative(n)
  return [1] if n == 1 || n == 0
  return [1, 1] if n == 2

  fibos = [1, 1]
  while fibos.size < n
    fibos << (fibos[-1] + fibos[-2])
  end

  fibos
end

# ---------------------------------------------------------------

def bsearch(arr, target)
  return nil unless arr.include?(target)

  target_idx = 0
  mid_idx = arr.length / 2
  return mid_idx if target == arr[mid_idx]

  left = arr[0...mid_idx]
  right = arr[(mid_idx + 1)..-1]

  if target < arr[mid_idx]
    target_idx = bsearch(left, target)
  else
    target_idx += mid_idx + 1 + bsearch(right, target)
  end

  target_idx
end

# ---------------------------------------------------------------

def merge_sort(arr)
  return arr if arr.empty? || arr.length == 1

  left = arr[0...arr.length / 2]
  right = arr[arr.length / 2..-1]

  left_sorted = merge_sort(left)
  right_sorted = merge_sort(right)

  merge!(left_sorted, right_sorted)
end


def merge!(arr1, arr2)
  merged_ary = []

  until [arr1, arr2].any? { |arr| arr.empty?}

    if arr1.first <=> arr2.first == 1    #arr1.first > arr2.first
      merged_ary << arr2.shift
    else                                 #arr1.first < arr2.first, or ==
      merged_ary << arr1.shift
    end
  end

  merged_ary + arr1 + arr2 #empty arrays won't change anything
end

# -----------------------------------------------------------------





# def make_change(total, coins)
#   best_change = []
#   ways_to_make_change = []
#   return best_change if coins.empty? || coins.last > total
#   these_coins = coins.dup
#   remainder = total
#
#     # debugger
#     if these_coins.first < remainder
#       best_change << these_coins.first
#       remainder -= these_coins.first
#       ways_to_make_change += make_change(remainder, these_coins)
#     else # if we can't make change with this coin
#       these_coins.shift
#       best_change += make_change(remainder, these_coins)
#     end
#
#     p "ways to make change are #{ways_to_make_change}"
#
#     change_lengths = ways_to_make_change.map(&:length)
#     shortest_length = change_lengths.min
#     shortest_change_ways = ways_to_make_change.select do |way|
#       way.length == shortest_length
#     end
#
#     p "change lengths are #{change_lengths}"
#     p "shortest length is #{shortest_length}"
#     p "shortest ways are #{shortest_change_ways}"
#
#   shortest_change_ways[0]
# end

#
# class ChangeMaker
#   attr_accessor :cash, :coins, :change
#
#   def initialize(cash, coins)
#     @cash = cash
#     @coins = coins.sort.reverse
#     @change = []
#   end
#
#   def make_change
#      return if coins.empty?
#      num_biggest_coins = cash / coins[0]
#      p num_biggest_coins
#      num_biggest_coins.times do
#        change << coins[0]
#        @cash -= coins[0]
#      end
#
#      coins.shift
#      self.make_change
#   end
# end

# p make_change(14, [10, 7, 1])
