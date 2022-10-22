# frozen_string_literal: true

class Draw
  attr_reader :ingredients

  def initialize(ingredients)
    @ingredients = ingredients
  end

  def valid?(receipt)
    return false if receipt.each_with_index.any? { _1.positive? && magimin[_2].zero? }

    sum_i = receipt.sum

    new_magimin = magimin.map { _1.as_percentage_of(total_maginim) }
    receipt.each_with_index.all? do |i, index|
      next true if i.zero?

      (i.as_percentage_of(sum_i).to_f - new_magimin[index].to_f).abs < 7
    end
  end

  def magimin
    @magimin ||= @ingredients.map(&:magimin).transpose.map(&:sum)
  end

  def total_price
    @ingredients.sum(&:price)
  end

  def ratio
    total_maginim.to_f / total_price
  end

  def total_maginim
    magimin.sum
  end

  private

  def magimin_to_base(m, index, base, receipt)
    d = receipt[index].to_f / base.to_f
    return 0 if d.zero?

    m.to_f / d
  end
end
