# frozen_string_literal: true

require 'csv'

def generate_csv(ingredients, capacity)
  CSV.open('temp.csv', 'w') do |csv|
    ingredients.each do |ingredient|
      [ingredient[:full_count], capacity].min.times do
        csv << ingredient.magimin + [ingredient.price, ingredient.name, ingredient.taste, ingredient.touch, ingredient.smell, ingredient.sight, ingredient.sound]
      end
    end
  end
end
