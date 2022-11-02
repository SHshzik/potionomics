# frozen_string_literal: true

def generate_brew(capacity, maxi, receipt, brew_name: 'brew.csv')
  result = `python genetic.py #{capacity} #{maxi['max_a']} #{maxi['max_b']} #{maxi['max_c']} #{maxi['max_d']} #{maxi['max_e']} #{receipt.join(',')}`

  File.write(brew_name, result)

  ingredients = CSV.read(brew_name).map { Ingredient.first(name: _1[0]) }

  p ingredients.sum(&:total_magimin)
  p ingredients.map(&:magimin).transpose.map(&:sum)
  p ingredients.sum(&:price)
  ingredients.each do |ingredient|
    p "#{ingredient.name}, #{ingredient.magimin}"
  end
end
