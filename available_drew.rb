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
ingredients = db.execute('select * from ingredients where available > 0')
                .map { |row| Ingredient.new(*row, 1) }
                .select { _1.suits?(selected_potion.receipt) }

capacity = cli.ask("Вместимость ингредиентов: ", Integer)
max_magimin = cli.ask("Максимум магии: ", Integer)
min_magimin = cli.ask("Минимум магии: ", Integer) { |q| q.default = 0 }

draws = []
(2..capacity).each do |i|
  draws += ingredients.repeated_combination(i)
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

p '------'
p '------'
p 'IDEAL!'

magic_number = [
  9, 19, 29, 39,
  74, 89, 104, 114,
  169, 194, 214, 234,
  314, 344, 369, 399
]

draws.select { magic_number.include?(_1.total_maginim) }.sort_by(&:total_maginim).each do |draw|
  p draw.total_price
  p "#{draw.magimin} - #{draw.total_maginim}"
  pp draw.ingredients.map { "#{_1.name} (#{_1.magimin}) (#{_1.count})" }
  p draw.ratio
  p '----------------------------'
end
