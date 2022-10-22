# frozen_string_literal: true

require './sequel_init'

class Ingredient < Sequel::Model
  def magimin
    @magimin ||= [a, b, c, d, e]
  end

  def total_magimin
    magimin.sum
  end
end
