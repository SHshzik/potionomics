# frozen_string_literal: true

require 'csv'

def generate_csv(ingredients, capacity)
  CSV.open('temp.csv', 'w') do |csv|
    ingredients.each do |ingredient|
      [ingredient[:full_count], capacity].min.times do
        csv << ingredient.magimin + [ingredient.price, ingredient.name]
      end
    end
  end
end
