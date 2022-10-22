# frozen_string_literal: true

require 'highline'
require './models/potion'
require './models/ingredient'
require './models/brew'
require './models/brew_needed_ingredient'

cli = HighLine.new

ingredients = Ingredient.all

capacity = cli.ask("Вместимость ингредиентов: ", Integer)

Potion.all.each do |potion|
  ingredients.repeated_combination(capacity)
             .select { Brew.valid?(_1, potion.receipt) }
             .each do |ingredients|
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
