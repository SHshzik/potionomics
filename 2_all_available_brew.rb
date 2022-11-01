# frozen_string_literal: true

require 'csv' # TODO: mv to script
require 'highline'
require 'percentage'
require './models/ingredient'
require './scripts/select_potion'
require './scripts/generate_csv'
require './scripts/generate_max_magimin'
require './scripts/generate_brew'

cli = HighLine.new
selected_potion = get_selected_potion(cli)
capacity = cli.ask("Вместимость ингредиентов: ", Integer)
max_magimin = cli.ask("Максимум магии: ", Integer)

ingredients = Ingredient.where(available: true)
                        .left_join(:items, ingredient_id: :id)
                        .select_all(:ingredients)
                        .select_append(Sequel.as(Sequel[:shop_count] + Sequel.function(:ifnull, Sequel[:count], 0), :full_count))
                        .where { a + b + c + d + e > 20 } # TODO: more calculate
                        .all

generate_csv(ingredients, capacity)
maxi = generate_max_magimin(selected_potion, max_magimin)
generate_brew(capacity, maxi, brew_name: 'brew1.csv')
