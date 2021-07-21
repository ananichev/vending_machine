# frozen_string_literal: true

class ProductRack
  class OutOfStockError < StandardError
    def initialize(product_name)
      super("#{product_name} is out of stock")
    end
  end

  def initialize(products = [])
    @products = products
  end

  def list
    @products.map(&:name).uniq
  end

  def issue(name)
    index = @products.index { |product| product.name == name }
    raise OutOfStockError, name unless index

    @products.delete_at(index)
  end
end
