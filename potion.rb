# frozen_string_literal: true

class Potion
  attr_reader :name

  def initialize(name, a, b, c, d, e)
    @name = name
    @a_val = a
    @b_val = b
    @c_val = c
    @d_val = d
    @e_val = e
  end

  def receipt
    @receipt ||= [@a_val, @b_val, @c_val, @d_val, @e_val]
  end
end
