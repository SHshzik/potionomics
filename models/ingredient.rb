# frozen_string_literal: true

require './sequel_init'

class Ingredient < Sequel::Model
  dataset_module do
    def for_potion(potion)
      scope = self
      potion.hash_receipt.each do |key, value|
        scope = scope.where(Sequel[key] => 0) if value.zero?
      end
      scope
    end
  end

  def magimin
    @magimin ||= [a, b, c, d, e]
  end

  def total_magimin
    magimin.sum
  end

  def hash_magimin
    @hash_magimin ||= {
      a: a,
      b: b,
      c: c,
      d: d,
      e: e
    }
  end
end
