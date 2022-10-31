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

val = cli.ask("Число: ", Integer)

item_exist = Item.first(ingredient: selected_ingredient)

if item_exist
    item_exist.count += val
    if item_exist.count > 0
        item_exist.save
    else
        item_exist.destroy
    end
else
    Item.create(ingredient: selected_ingredient, count: val)
end
