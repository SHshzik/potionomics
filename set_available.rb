# frozen_string_literal: true

require 'highline'
require './models/potion'
require './models/ingredient'
# require './models/brew'
# require './models/brew_needed_ingredient'

cli = HighLine.new

capacity = cli.ask("Вместимость ингредиентов: ", Integer)

# def generate(combinations)
#   combinations.each_with_index do |ingredients, index|
#     p "#{index}"

#     if Brew.valid?(ingredients, potion.receipt)
#       created = false
#       brew = Brew.find_or_create(ingredient_ids: ingredients.sort_by(&:id).map(&:id).to_s) do |brew|
#         created = true
#         brew.potion = potion
#         magimin = ingredients.map(&:magimin).transpose.map(&:sum)
#         brew.magimin = magimin.to_s
#         brew.total_magimin = magimin.sum
#         brew.total_price = ingredients.sum(&:price)
#         brew.ingredients_count = capacity
#       end
#       if created
#         ingredients.group_by { _1 }.transform_values(&:count).each do |ingredient, count|
#           BrewNeededIngredient.create do |brew_needed_ingredient|
#             brew_needed_ingredient.brew = brew
#             brew_needed_ingredient.ingredient = ingredient
#             brew_needed_ingredient.count = count
#           end
#         end
#       end
#     end
#   end
# end
