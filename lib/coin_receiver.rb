# frozen_string_literal: true

require 'forwardable'

class CoinReceiver
  class OutOfCoinError < StandardError; end

  extend Forwardable
  def_delegators :@coins, :to_a

  def initialize(coins: [])
    @coins = coins
  end

  def amount
    @coins.map(&:value).inject(0, :+)
  end

  def upload(coins)
    @coins.concat(coins)
  end

  def issue(amount)
    raise OutOfCoinError, 'No suitable coin to issue' if @coins.empty?

    change_transaction = @coins.dup
    calculate_change(amount, change_transaction).tap { @coins = change_transaction }
  end

  private

  def calculate_change(amount, change_transaction)
    change = Coin::COINS.reverse.each_with_object([]) do |coin, arr|
      next if (amount / coin).zero?

      (amount / coin).times do
        found = change_transaction.detect { |c| c.value == coin }
        break unless found

        arr << change_transaction.delete_at(change_transaction.index(found))
      end
      amount -= arr.compact.map(&:value).inject(0, :+)
    end

    raise OutOfCoinError, 'No suitable coin to issue' if amount != 0

    change
  end
end
