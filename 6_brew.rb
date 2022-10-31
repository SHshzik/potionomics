# frozen_string_literal: true

require 'csv'
require './models/ingredient'
require './models/item'

needed_ingredients = CSV.read("brew.csv")

needed_ingredients.each do |needed_ingredient|
  item = Item.join(:ingredients, id: :ingredient_id).where(Sequel[:ingredients][:name] => needed_ingredient[0]).select_all(:items).first
  p item
  item.count -= 1
  if item.count <= 0
    item.destroy
  else
    item.save
  end
end
