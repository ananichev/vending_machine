# frozen_string_literal: true

require_relative 'coin_receiver'
require_relative 'product'
require_relative 'product_rack'

class VendingMachine
  def initialize(rack: ProductRack.new, coin_receiver: CoinReceiver.new)
    @rack = rack
    @coin_receiver = coin_receiver
    reset_inserted_amount
    reset_selected_product
  end

  def list_products
    @rack.list
  end

  def insert(coin)
    asserted = coin.is_a?(Coin) ? coin : Coin.new(coin)
    @inserted_amount.upload([asserted])
  end

  def select(name)
    @selected = @rack.issue(name)
  rescue ProductRack::OutOfStockError => e
    e.message
  end

  def vend
    return 'No product selected' unless @selected

    return [vend_product] if coins_inserted == @selected.price
    return [issue_change, vend_product] if coins_inserted > @selected.price
    return 'Insert more coins' if coins_inserted < @selected.price

    'Select a product'
  rescue CoinReceiver::OutOfCoinError => e
    e.message
  end

  def coins_inserted
    @inserted_amount.amount
  end

  private

  def reset_selected_product
    @selected = nil
  end

  def reset_inserted_amount
    @inserted_amount = CoinReceiver.new
  end

  def vend_product
    @selected.tap do
      commit_payment
      reset_selected_product
    end
  end

  def commit_payment
    @coin_receiver.upload(@inserted_amount.to_a)
    reset_inserted_amount
  end

  def issue_change
    @coin_receiver.issue(coins_inserted - @selected.price)
  end
end
