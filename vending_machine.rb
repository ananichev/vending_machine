# frozen_string_literal: true

require 'tty-prompt'

Dir['lib/*.rb'].each { |file| require_relative file }

prompt = TTY::Prompt.new

products = [Product.new(name: 'CocaCola', price: 125), Product.new(name: 'Snickers', price: 75), Product.new(name: 'Chips', price: 50)]

cr = CoinReceiver.new(coins: [Coin.new(25), Coin.new(25), Coin.new(25), Coin.new(50), Coin.new(50), Coin.new(100)])
pr = ProductRack.new(products)
vm = VendingMachine.new(rack: pr, coin_receiver: cr)

selected = prompt.select('Select product', products.map(&:name))
puts "You are selected #{selected}, price #{products.find { |p| p.name == selected }.price}"
vm.select(selected)

action = ''

while action != 'Exit'
  puts "Balance: #{vm.coins_inserted}"

  action = prompt.select('Action', ['Insert coin', 'Vend', 'Exit'])
  case action
  when 'Insert coin'
    coin = prompt.ask('Please insert coin') do |c|
      c.required true
      c.validate ->(input) { Coin::COINS.include?(input.to_i) }
      c.messages[:valid?] = "Invalid coin denomination: %{value}, must be one of #{Coin::COINS}"
    end
    vm.insert(coin.to_i)
  when 'Vend'
    res = vm.vend
    puts res.to_s
    action = 'Exit' if res.is_a?(Array)
  else
    action = 'Exit'
  end
end
