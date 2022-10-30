# frozen_string_literal: true

require 'csv'
require './models/ingredient'

table = CSV.parse(File.read('1.csv'), headers: true)

def trait(row, name)
  if row[name] == 'Good'
    1
  elsif row[name] == 'Bad'
    -1
  elsif row[name].nil? or row[name] == "?"
    0
  else
    p row[name]
    raise 'error'
  end
end

table.each do |row|
  p row['Ingredients']
  # p row['A']
  # p row['B']
  # p row['C']
  # p row['D']
  # p row['E']
  # p row['Price (Quinn)']

  taste = trait(row, 'Taste')
  touch = trait(row, 'Touch')
  smell = trait(row, 'Smell')
  sight = trait(row, 'Sight')
  sound = trait(row, 'Sound')
  ingredient = Ingredient.find_or_create(
    name: row['Ingredients'],
    a: row['A'].to_i,
    b: row['B'].to_i,
    c: row['C'].to_i,
    d: row['D'].to_i,
    e: row['E'].to_i,
    price: row['Price (Quinn)'].to_i
  )
  ingredient.taste = taste
  ingredient.touch = touch
  ingredient.smell = smell
  ingredient.sight = sight
  ingredient.sound = sound
  ingredient.save
end

p 'WARNING' if table.count != Ingredient.count
