# frozen_string_literal: true

require './models/potion'

def get_selected_potion(cli)
  potions = Potion.all

  # select potion for brew
  selected_potion = nil
  cli.choose do |menu|
    menu.prompt = "Выбери зелье: "
    potions.each do |potion|
      menu.choice(potion.name) { selected_potion = potion }
    end
  end
  selected_potion
end
