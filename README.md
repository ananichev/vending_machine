# Vending Machine

## Task
Design a vending machine in code. The vending machine, once a product is selected and the appropriate amount of money (coins) is inserted, should return that product. It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough (change should be printed as coin * count and as minimum coins as possible).
Keep in mind that you need to manage the scenario where the item is out of stock or the machine does not have enough change to return to the customer.
Available coins: `0.25, 0.5, 1, 2, 3, 5`

## Get Started

1. Run bundle install 
    ```bash
    bundle install
    ```

2. Run IRB and put the following
   ```bash
   require "./lib/coin"
   require "./lib/vending_machine"
   
   cr = CoinReceiver.new(coins: [Coin.new(25)])
   pr = ProductRack.new([Product.new(name: 'CocaCola', price: 125)])
   vm = VendingMachine.new(rack: pr, coin_receiver: cr)
   
   vm.list_products # => ["CocaCola"]
   
   vm.select('CocaCola')
   vm.insert(100)
   vm.insert(50)
   vm.vend
   ```
