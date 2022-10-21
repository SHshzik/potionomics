# frozen_string_literal: true

class Ingredient
  attr_reader :name, :price, :count

  def initialize(name, a, b, c, d, e, price, available, count)
    @name = name
    @a_mag = a
    @b_mag = b
    @c_mag = c
    @d_mag = d
    @e_mag = e
    @price = price
    @available = available
    @count = count
  end

  def suits?(receipt)
    return false if receipt.each_with_index.any? { _1.zero? && magimin[_2].positive? }

    true
  end

  def magimin
    @magimin ||= [@a_mag, @b_mag, @c_mag, @d_mag, @e_mag]
  end

  def total_magimin
    magimin.sum
  end
end
