# frozen_string_literal: true

require './sequel_init'

class Potion < Sequel::Model
  def receipt
    @receipt ||= [a, b, c, d, e]
  end
end
