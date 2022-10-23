# frozen_string_literal: true

require 'highline'
require './models/potion'
require './models/ingredient'
require './models/brew'
require './models/brew_needed_ingredient'

cli = HighLine.new

capacity = cli.ask("Вместимость ингредиентов: ", Integer)

Potion.all.each_with_index do |potion, index|
  Ingredient.for_potion(potion).where(available: true).to_a.repeated_combination(capacity)
             .each_with_index do |ingredients, index2|
               p "#{index} - #{index2}"

               if Brew.valid?(ingredients, potion.receipt)
                 brew = Brew.create do |brew|
                   brew.potion = potion
                   magimin = ingredients.map(&:magimin).transpose.map(&:sum)
                   brew.magimin = magimin.to_s
                   brew.total_magimin = magimin.sum
                   brew.total_price = ingredients.sum(&:price)
                   brew.ingredients_count = capacity
                   brew.ingredient_ids = ingredients.sort_by(&:name).map(&:id).to_s
                 end
                 ingredients.group_by { _1 }.transform_values(&:count).each do |ingredient, count|
                   BrewNeededIngredient.create do |brew_needed_ingredient|
                     brew_needed_ingredient.brew = brew
                     brew_needed_ingredient.ingredient = ingredient
                     brew_needed_ingredient.count = count
                   end
                 end
               end
             end
end
