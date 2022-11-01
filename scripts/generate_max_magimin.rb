# frozen_string_literal: true

def generate_max_magimin(potion, max_magimin)
  maxi = {}
  sum_i = potion.receipt.sum
  potion.hash_receipt.each do |(key, value)|
    maxi["max_#{key}"] = (value.as_percentage_of(sum_i) * max_magimin).to_i
  end
  maxi
end
