# frozen_string_literal: true

require 'csv'
require './models/ingredient'

table = CSV.parse(File.read('1.csv'), headers: true)

table.each do |row|
  p row['Ingredients']
  p row['A']
  p row['B']
  p row['C']
  p row['D']
  p row['E']
  p row['Price (Quinn)']
  Ingredient.find_or_create(
    name: row['Ingredients'],
    a: row['A'].to_i,
    b: row['B'].to_i,
    c: row['C'].to_i,
    d: row['D'].to_i,
    e: row['E'].to_i,
    price: row['Price (Quinn)'].to_i
  )
end

p 'WARNING' if table.count != Ingredient.count
