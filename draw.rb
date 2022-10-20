# frozen_string_literal: true

class Draw
  attr_reader :ingredients

  def initialize(ingredients)
    @ingredients = ingredients
  end

  def valid?(receipt)
    return false if receipt.each_with_index.any? { _1.positive? && magimin[_2].zero? }

    base = receipt.select(&:positive?).min
    new_magimin = magimin
                    .map
                    .with_index { |m, index| magimin_to_base(m, index, base, receipt) }

    new_magimin.select(&:positive?).each_cons(2).all? { _1 == _2 }
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
