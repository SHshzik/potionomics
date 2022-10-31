# frozen_string_literal: true

require 'highline'
require './models/item'
require './models/ingredient'

cli = HighLine.new

name = cli.ask("Пару букв ингредиента: ")

selected_ingredient = nil
cli.choose do |menu|
  menu.prompt = "Выбери ингредиент: "
  Ingredient.where(Sequel.like(Sequel.function(:lower, :name), "%#{name}%")).all.each do |ingredient|
    menu.choice(ingredient.name) { selected_ingredient = ingredient }
  end
end

selected_ingredient.available = true
selected_ingredient.save

item = Item.first(ingredient_id: selected_ingredient.id)
item.count -= 1
if item.count > 0
  item.save
else
  item.destroy
end
