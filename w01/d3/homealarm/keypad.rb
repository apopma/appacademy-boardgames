class Keypad
  attr_reader :code_bank

  def initialize(code_length = 4, mode_keys = [1, 2, 3])
    @key_history = []                           # code_length + 1 most recent keypresses
    @code_bank = Array.new(10**code_length, 0)  # 0 => '0000', 1 => '0001'... 9999 => '9999'
    @code_length = code_length
    @mode_keys = mode_keys
  end

  def press(pressed_key)
    @key_history << pressed_key
    if @key_history.length > @code_length + 1
      @key_history.shift
    end

    if @mode_keys.include?(@key_history.last) && @key_history.length == @code_length + 1
      this_code = @key_history[0...@code_length].join.to_i
      @code_bank[this_code] += 1
    end
  end

  def all_codes_entered?
    @code_bank.all? { |code| code >= 1 }
  end
end

