require_relative "keypad"

class KeypadTester
  def initialize(length = 4, mode_keys = [1, 2, 3])
    @length = length
    @mode_keys = mode_keys
    @keypad = Keypad.new(@length, @mode_keys)
    @keystrokes = 0
  end

  def greedy_algorithm
    num_to_test = 0

    until @keypad.all_codes_entered?
      keys = []
      padding = (length) - (num_to_test.to_s.length)
      padding.times { keys << 0 }

      padded_num = num_to_test.to_s.split('')
      padded_num.each { |num| keys << num.to_i }
      keys << 1

      keys.each do |num|
        press_key(num)
      end

      num_to_test += 1
    end

    puts "The greedy algorithm took #{@keystrokes} keystrokes to finish."
    repeated_codes = @keypad.code_bank.count { |tries| tries > 1 }
    puts "Code bank contained #{repeated_codes} codes tried more than once."
  end

  def press_key(key)
    @keypad.press(key)
    @keystrokes += 1
  end
end

KeypadTester.new.greedy_algorithm

