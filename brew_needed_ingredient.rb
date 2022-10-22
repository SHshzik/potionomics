# frozen_string_literal: true

require './sequel_init'

class BrewNeededIngredient < Sequel::Model
  many_to_one :brew
  many_to_one :ingredient
end
