require 'sqlite3'
require 'highline'
require './ingredient'
require './draw'
require './potion'

db = SQLite3::Database.new 'potionomics.db'
cli = HighLine.new

potions = db.execute('select * from potions').map { Potion.new(*_1) }

# select potion for draw
selected_potion = nil
cli.choose do |menu|
  menu.prompt = "Выбери зелье: "
  potions.each do |potion|
    menu.choice(potion.name) { selected_potion = potion }
  end
end

# prepare inventory for receipt
ingredients = db.execute('select * from inventory inner join ingredients on ingredients.name = inventory.ingredient')
                .map { |row| Ingredient.new(*row[2..], row[1]) }
                .select { _1.suits?(selected_potion.receipt) }

capacity = cli.ask("Вместимость ингредиентов: ", Integer)
max_magimin = cli.ask("Максимум магии: ", Integer)
min_magimin = cli.ask("Минимум магии: ", Integer) { |q| q.default = 0 }

def check_ingredients(comb)
  grouped = comb.group_by(&:name).transform_values(&:count)
  comb.all? { grouped[_1.name] <= _1.count }
end

draws = []
(1..capacity).each do |i|
  draws += ingredients.repeated_combination(i)
                      .select { check_ingredients(_1) }
                      .filter { _1.sum(&:total_magimin) < max_magimin }
                      .filter { _1.sum(&:total_magimin) > min_magimin }
                      .map { Draw.new(_1) }
                      .select { _1.valid?(selected_potion.receipt) }
end

draws.sort_by(&:total_maginim).each do |draw|
  p draw.total_price
  p "#{draw.magimin} - #{draw.total_maginim}"
  pp draw.ingredients.map { "#{_1.name} (#{_1.magimin}) (#{_1.count})" }
  p draw.ratio
  p '----------------------------'
end
