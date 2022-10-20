require 'sqlite3'
require './ingredient'
require './draw'

db = SQLite3::Database.new 'potionomics.db'

ingredients = []
db.execute('select * from ingredients where count > 0') do |row|
  ingredients << Ingredient.new(*row)
end

receipt = [1, 1, 0, 0, 0]
capacity = 4
max_magimin = 110

filtered_ingredients = ingredients.select { _1.suits?(receipt) }

pp filtered_ingredients
          .repeated_combination(capacity)
          .filter { |ingredients| ingredients.sum(&:total_magimin) < max_magimin }
          .map { Draw.new(_1) }
          .select { _1.valid?(receipt) }
          .sort_by(&:total_price)
          # .count

# pp validated

# 1 2
# 8 16
