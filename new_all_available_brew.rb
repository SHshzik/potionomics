# frozen_string_literal: true

require 'csv'
require 'highline'
require 'percentage'
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
max_magimin = cli.ask("Максимум магии: ", Integer)

ingredients = Ingredient
                        # .for_potion(selected_potion)
                        .where(available: true)
                        .where(disable: false)
                        .left_join(:items, ingredient_id: :id)
                        .select_all(:ingredients)
                        .select_append(Sequel.as(Sequel[:shop_count] + Sequel.function(:ifnull, Sequel[:count], 0), :full_count))
                        .all

CSV.open('temp.csv', 'w') do |csv|
  ingredients.each do |ingredient|
    [ingredient[:full_count], capacity].min.times do
      csv << ingredient.magimin + [ingredient.price, ingredient.name, ingredient.taste, ingredient.touch, ingredient.smell, ingredient.sight, ingredient.sound]
    end
  end
end

maxi = {}
sum_i = selected_potion.receipt.sum
selected_potion.hash_receipt.each_with_index do |(key, value), index|
  maxi["max_#{key}"] = (value.as_percentage_of(sum_i) * max_magimin).to_i
end

result = `python genetic.py #{capacity} #{maxi['max_a']} #{maxi['max_b']} #{maxi['max_c']} #{maxi['max_d']} #{maxi['max_e']}`

print(result)
