# frozen_string_literal: true
require './sequel_init'

class Item < Sequel::Model
	many_to_one :ingredient
end
