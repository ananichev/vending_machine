# frozen_string_literal: true

class Coin
  COINS = [25, 50, 100, 200, 300, 500].freeze

  attr_reader :value

  def initialize(value)
    @value = value
    raise ArgumentError, 'Invalid value' unless valid?
  end

  private

  def valid?
    COINS.include?(value)
  end
end
