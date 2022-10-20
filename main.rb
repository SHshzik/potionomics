require 'sqlite3'
require './ingredient'

db = SQLite3::Database.new 'potionomics.db'

ingredients = []
db.execute( 'select * from ingredients' ) do |row|
  ingredients << Ingredient.new(*row)
end

receipt = [1, 1, 0, 0, 0]
capacity = 4
max_magimin = 110

filtered_ingredients = ingredients.select { _1.suits?(receipt) }

filtered_ingredients
  .repeated_combination(capacity)
  .filter { |ingredients| ingredients.sum(&:total_magimin) < max_magimin }.first
