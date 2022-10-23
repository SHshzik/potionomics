# frozen_string_literal: true

require 'percentage'
require './sequel_init'

class Brew < Sequel::Model
  MAGIC_NUMBER = [
    9, 19, 29, 39,
    74, 89, 104, 114,
    169, 194, 214, 234,
    314, 344, 369, 399
  ]

  many_to_one :potion
  one_to_many :brew_needed_ingredients

  dataset_module do
    def by_capacity(capacity)
      where(Sequel[:brews][:ingredients_count] => capacity)
    end
  end

  def self.valid?(ingredients, receipt)
    magimin = ingredients.map(&:magimin).transpose.map(&:sum)
    total_maginim = magimin.sum
      
    return false if receipt.each_with_index.any? { _1.positive? && magimin[_2].zero? }

    sum_i = receipt.sum
    new_magimin = magimin.map { _1.as_percentage_of(total_maginim) }

    receipt.each_with_index.all? do |i, index|
      next true if i.zero?

      i.as_percentage_of(sum_i) == new_magimin[index]
    end
  end
end
