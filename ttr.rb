# frozen_string_literal: true

# require 'highline'
require './models/ingredient'
require './models/potion'
require './models/brew'

# class Backpack
#   attr_reader :items, :price
#
#   def initialize(items, price)
#     @items = items
#     @price = price
#   end
# end

potion = Potion[9]
ingredients = Ingredient.for_potion(potion).where(available: true).all
pp ingredients.count
def select_items(ingredients, magimin, potion)
  # binding.irb
  keys = magimin.select { potion.receipt_keys.include? _1 }.group_by { _2 }.min_by { _1 }&.last&.map { _1[0] }
  return ingredients if keys.nil?

  ingredients.select do |ingredient|
    keys.any? do |k|
      ingredient.send(k) > 0
    end
  end
end

def knapsack(ingredients, max_ingredients, max_magimin, current_magimin = nil, lookup = nil, brew: nil, potion:, cc:)
  lookup ||= {}
  brew ||= []
  current_magimin ||= {}

  return [] if max_ingredients.zero?

  return lookup[brew.map(&:id).sort] if lookup.include?(brew.map(&:id).sort)

  items = select_items(ingredients, current_magimin, potion)

  max_value = []
  items.each do |ingredient|
    if ingredient.total_magimin <= max_magimin
      new_brew = brew + [ingredient]
      new_current_magimin = [current_magimin, ingredient.hash_magimin].reduce({}) do |s, l|
        s.merge(l) { |_, a, b| a + b }
      end
      new_comb = [ingredient] + knapsack(ingredients, max_ingredients - 1, max_magimin - ingredient.total_magimin, new_current_magimin, lookup, brew: new_brew, potion: potion, cc: cc)

      cc[:count] += 1 if max_ingredients == 1
      if new_comb.sum(&:total_magimin) > max_value.sum(&:total_magimin) && (max_ingredients != 1 || Brew.valid?(new_brew, potion.receipt))
        max_value = new_comb
      end
    end
  end
  lookup[brew.map(&:id).sort] = max_value

  max_value
end

qwe = { count: 0 }
pp knapsack(ingredients, 8,240, potion: potion, cc: qwe)
p qwe
# potion = Potion[1]
# ingredients = Ingredient.for_potion(potion).all
# magimin = { a: 1, b: 2 }
# pp select_items(ingredients, magimin, potion)
# pp select_items(ingredients, magimin, potion).count



###########################################

#def knapsack(values, weights, k, lookup=None):
#     lookup = {} if lookup is None else lookup
#     if k in lookup:
#         return lookup[k]
#     max_value = 0
#     for i in range(len(values)):
#         if weights[i] <= k:
#             max_value = max(max_value, values[i]+knapsack(values, weights, k-weights[i], lookup))
#     lookup[k] = max_value
#     return lookup[k]

# def knapsack(items, k, i, lookup = nil)
#   lookup ||= {}
#   return lookup[[i, k]] if lookup.include?([i, k])
#
#   if i == items.count
#     0
#   elsif k < 0
#     -Float::INFINITY
#   else
#     lookup[[i, k]] = [
#       items[i].price + knapsack(items, k - items[i].total_magimin, i + 1, lookup),
#       knapsack(items, k, i + 1)
#     ].max
#
#     lookup[[i, k]]
#   end
# end

# pp knapsack(items, k, 0)

#
# n = 6 # число ингредиентов
# k = 115 # максимум магии
# items = Ingredient.where(id: [3, 4, 5, 6, 11, 12]).all # ingredients
# bp = []
# (0..6).each do |i|
#   (0..k).each do |j|
#     bp[i] ||= []
#     if i.zero? || j.zero?
#       bp[i][j] = Backpack.new([], 0)
#     elsif i == 1
#       bp[i][j] = items[0].total_magimin <= j ? Backpack.new([items[0]], items[0].price) : Backpack.new([], 0)
#     else
#       if items[i - 1].total_magimin > j
#         bp[i][j] = bp[i - 1][j];
#       else
#         newPrice = items[i - 1].price + bp[i - 1][j - items[i - 1].total_magimin].price
#         if (bp[i - 1][j].price > newPrice)
#           bp[i][j] = bp[i - 1][j];
#         else
#           bp[i][j] = Backpack.new(
#             [
#               items[i - 1],
#               bp[i - 1][j - items[i - 1].total_magimin].items
#             ].flatten,
#             newPrice
#           )
#         end
#       end
#     end
#   end
# end
#
# pp bp.last.max_by { |bpr| bpr.items.sum { |item| item.total_magimin } }

#List<Backpack> lastColumn = Arrays.stream(backpack).map(row -> row[row.length - 1]).collect(Collectors.toList());
#
#
# Backpack backpackWithMax = lastColumn.stream().max(Comparator.comparing(Backpack::getPrice)).orElse(new Backpack(null, 0));

#/*рассчитаем цену очередного предмета + максимальную цену для (максимально возможный для рюкзака вес − вес предмета)*/
#   int newPrice = items[i - 1].getPrice() + bp[i - 1][j - items[i - 1].getWeight()].getPrice();
#  if (bp[i - 1][j].getPrice() > newPrice) //если предыдущий максимум больше
#       bp[i][j] = bp[i - 1][j]; //запишем его
#   else {
#       /*иначе фиксируем новый максимум: текущий предмет + стоимость свободного пространства*/
#       bp[i][j] = new Backpack(Stream.concat(Arrays.stream(new Item[]{items[i - 1]}),
#               Arrays.stream(bp[i - 1][j - items[i - 1].getWeight()].getItems())).toArray(Item[]::new), newPrice);
#   }

# for (int i = 0; i < n + 1; i++) {
#    for (int j = 0; j < k + 1; j++) {
#        if (i == 0 || j == 0) { //нулевую строку и столбец заполняем нулями
#            bp[i][j] = new Backpack(new Item[]{}, 0);
#        } else if (i == 1) {
#            /*первая строка заполняется просто: первый предмет кладём или не кладём в зависимости от веса*/
#            bp[1][j] = items[0].getWeight() <= j ? new Backpack(new Item[]{items[0]}, items[0].getPrice())
#                    : new Backpack(new Item[]{}, 0);
#        } else {
#            if (items[i - 1].getWeight() > j) //если очередной предмет не влезает в рюкзак,
#                bp[i][j] = bp[i - 1][j];    //записываем предыдущий максимум
#            else {
#                /*рассчитаем цену очередного предмета + максимальную цену для (максимально возможный для рюкзака вес − вес предмета)*/
#                int newPrice = items[i - 1].getPrice() + bp[i - 1][j - items[i - 1].getWeight()].getPrice();
#                if (bp[i - 1][j].getPrice() > newPrice) //если предыдущий максимум больше
#                    bp[i][j] = bp[i - 1][j]; //запишем его
#                else {
#                    /*иначе фиксируем новый максимум: текущий предмет + стоимость свободного пространства*/
#                    bp[i][j] = new Backpack(Stream.concat(Arrays.stream(new Item[]{items[i - 1]}),
#                            Arrays.stream(bp[i - 1][j - items[i - 1].getWeight()].getItems())).toArray(Item[]::new), newPrice);
#                }
#            }
#        }
#    }
# }

# def knapsack(values, weights, k, i, lookup = nil)
#   lookup ||= {}
#   return lookup[[i, k]] if lookup.include?([i, k])
#
#   if i == values.count
#     0
#   elsif k < 0
#     -Float::INFINITY
#   else
#     lookup[[i, k]] = max(
#       values[i] + knapsack(values, weights, k - weights[i], i + 1, lookup),
#       knapsack(values, weights, k, i + 1)
#     )
#
#     lookup[[i, k]]
#   end
# end

# def knapsack(values, weights, k, i=0, lookup=None):
#     lookup = {} if lookup is None else lookup
#     if (i, k) in lookup:
#         return lookup[(i, k)]
#     if i == len(values):
#         return 0
#     elif k < 0:
#         return float('-inf')
#     else:
#         lookup[(i, k)] = max(values[i]+knapsack(values, weights, k-weights[i], i+1, lookup),
#                              knapsack(values, weights, k, i+1))
#         return lookup[(i, k)]

# int n = 3; //число строк = число вещей
# int k = 4; //грузоподъёмность рюкзака
# //массив вещей
# Item[] items = {new Item("гитара", 1, 1500),
#                 new Item("бензопила", 4, 3000),
#                 new Item("ноутбук", 3, 2000)};
# //массив промежуточных состояний рюкзака
# Backpack[][] bp = new Backpack[n + 1][k + 1];
