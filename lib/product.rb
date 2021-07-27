# frozen_string_literal: true

class Product
  attr_reader :name, :price

  def inspect
    name
  end

  def initialize(name:, price:)
    @name = name
    @price = price
  end
end
