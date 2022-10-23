# frozen_string_literal: true

require 'highline'
require './models/potion'
require './models/brew'
require './models/brew_needed_ingredient'
require './models/ingredient'

cli = HighLine.new
potions = Potion.all

# select potion for brew
selected_potion = nil
cli.choose do |menu|
  menu.prompt = "Выбери зелье: "
  potions.each do |potion|
    menu.choice(potion.name) { selected_potion = potion }
  end
end

capacity = cli.ask("Вместимость ингредиентов: ", Integer)

brews = selected_potion.brews_dataset
      .by_capacity(capacity)
      .select('brews.*')
      .join(:brew_needed_ingredients, brew_id: :id)
      .join(
        :items,
        Sequel[:brew_needed_ingredients][:ingredient_id] => Sequel[:items][:ingredient_id]
      ) { Sequel[:items][:count] >= Sequel[:brew_needed_ingredients][:count] }
      .group(Sequel[:brews][:id])
      .having(Sequel.function(:count, Sequel[:brew_needed_ingredients][:id]) => Sequel[:brews][:ingredients_count])
      .select_all(:brews)
      .to_a

brews.each do |brew|
  p "Total price: #{brew.total_price}"
  p "Magimin: #{brew.magimin} - #{brew.total_magimin}"
  brew.brew_needed_ingredients.each do |needed_ingredient|
    p "Игредиент: #{needed_ingredient.ingredient.name} #{needed_ingredient.ingredient.magimin} (#{needed_ingredient.count})"
  end
  p '----------------------------'
end
