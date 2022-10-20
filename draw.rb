# frozen_string_literal: true

class Draw
  delegate :count, to: :@ingredients

  def initialize(count)
    @ingredients = []
  end

  def add_ingredient(ingredient)
    @ingredients << ingredient
  end
end
