# frozen_string_literal: true

require 'highline'
require './potion'
require './ingredient'
require './brew'
require './brew_needed_ingredient'

cli = HighLine.new

potions = Potion.all

# select potion for draw
selected_potion = nil
cli.choose do |menu|
  menu.prompt = "Выбери зелье: "
  potions.each do |potion|
    menu.choice(potion.name) { selected_potion = potion }
  end
end

ingredients = Ingredient.all

capacity = cli.ask("Вместимость ингредиентов: ", Integer)

ingredients.repeated_combination(capacity)
           .select { Brew.valid?(_1, selected_potion.receipt) }
           .each do |ingredients|
             brew = Brew.create do |brew|
               brew.potion = selected_potion
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
