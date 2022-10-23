# frozen_string_literal: true

require './sequel_init'

class Potion < Sequel::Model
  one_to_many :brews

  def receipt
    @receipt ||= [a, b, c, d, e]
  end

  def hash_receipt
    {
      a: a,
      b: b,
      c: c,
      d: d,
      e: e
    }
  end
end
