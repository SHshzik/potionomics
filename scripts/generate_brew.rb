# frozen_string_literal: true

def generate_brew(capacity, maxi, brew_name: 'brew.csv')
  result = `python3 genetic.py #{capacity} #{maxi['max_a']} #{maxi['max_b']} #{maxi['max_c']} #{maxi['max_d']} #{maxi['max_e']}`

  File.write(brew_name, result)

  ingredients = CSV.read(brew_name).map { Ingredient.first(name: _1[0]) }

  p ingredients.sum(&:total_magimin)
  ingredients.each do |ingredient|
    p "#{ingredient.name}, #{ingredient.magimin}"
  end
end
