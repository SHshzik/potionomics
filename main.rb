require 'sqlite3'
require './ingredient'
require './draw'

db = SQLite3::Database.new 'potionomics.db'

ingredients = []
db.execute('select * from ingredients where available') do |row|
  ingredients << Ingredient.new(*row)
end

receipt = [3, 4, 3, 0, 0]
capacity = 8
max_magimin = 240
min_magimin = 100
# ingredients = ingredients.select { _1.count > 0 }
filtered_ingredients = ingredients.select { _1.suits?(receipt) }
                         
                        


def check_ingredients(comb)
  grouped = comb.group_by(&:name).transform_values(&:count)
  comb.all? { grouped[_1.name] <= _1.count }
end

draws = []
(8..capacity).each do |i|
  draws += filtered_ingredients
            .repeated_combination(i)
            # .select { check_ingredients(_1) }
            .filter { _1.sum(&:total_magimin) < max_magimin }
            .filter { _1.sum(&:total_magimin) > min_magimin }
            .map { Draw.new(_1) }
            .select { _1.valid?(receipt) }
end

draws.sort_by(&:total_maginim).each do |draw|
  p draw.total_price
  p "#{draw.magimin} - #{draw.total_maginim}"
  pp draw.ingredients.map { "#{_1.name} (#{_1.magimin}) (#{_1.count})" }
  p draw.ratio
end
